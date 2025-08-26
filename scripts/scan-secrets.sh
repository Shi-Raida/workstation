#!/bin/bash
# scan-secrets.sh - Local security scanning script for workstation provisioning
# Runs multiple security scans and generates a consolidated report

set -euo pipefail

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
REPORT_DIR="$PROJECT_ROOT/.security-reports"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}[$(date '+%H:%M:%S')] ${message}${NC}"
}

print_success() { print_status "$GREEN" "✅ $1"; }
print_error() { print_status "$RED" "❌ $1"; }
print_warning() { print_status "$YELLOW" "⚠️ $1"; }
print_info() { print_status "$BLUE" "ℹ️ $1"; }

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to ensure report directory exists
setup_report_dir() {
    mkdir -p "$REPORT_DIR"
    print_info "Reports will be saved to: $REPORT_DIR"
}

# Function to run gitleaks scan
run_gitleaks_scan() {
    print_info "Running gitleaks secrets detection..."

    if ! command_exists gitleaks; then
        print_error "gitleaks is not installed. Please install it first."
        return 1
    fi

    local report_file="$REPORT_DIR/gitleaks_${TIMESTAMP}.json"

    if gitleaks detect --source "$PROJECT_ROOT" --config "$PROJECT_ROOT/.gitleaks.toml" \
        --report-format json --report-path "$report_file" --verbose; then
        print_success "Gitleaks scan completed - No secrets found"
        echo "[]" > "$report_file"  # Empty results
        return 0
    else
        local exit_code=$?
        if [ -f "$report_file" ] && [ -s "$report_file" ]; then
            local secrets_count=$(jq length "$report_file" 2>/dev/null || echo "unknown")
            print_error "Gitleaks found $secrets_count potential secrets!"
            print_warning "Review the report at: $report_file"
            return $exit_code
        else
            print_error "Gitleaks scan failed with exit code $exit_code"
            return $exit_code
        fi
    fi
}

# Function to run Python security scans
run_python_scans() {
    print_info "Running Python security scans..."

    # Find Python files
    local python_files
    python_files=$(find "$PROJECT_ROOT" -name "*.py" -not -path "$PROJECT_ROOT/.venv/*" -not -path "$PROJECT_ROOT/.git/*")

    if [ -z "$python_files" ]; then
        print_warning "No Python files found to scan"
        return 0
    fi

    # Run bandit if available
    if command_exists bandit; then
        local bandit_report="$REPORT_DIR/bandit_${TIMESTAMP}.json"
        print_info "Running bandit Python security analysis..."

        if echo "$python_files" | xargs bandit -r -f json -o "$bandit_report" 2>/dev/null; then
            print_success "Bandit scan completed"
        else
            if [ -f "$bandit_report" ]; then
                local issues_count=$(jq '.results | length' "$bandit_report" 2>/dev/null || echo "0")
                print_warning "Bandit found $issues_count potential security issues"
            else
                print_error "Bandit scan failed"
            fi
        fi
    else
        print_warning "bandit not installed - skipping Python security analysis"
    fi

    # Run safety check if available
    if command_exists safety; then
        print_info "Running safety dependency vulnerability check..."
        local safety_report="$REPORT_DIR/safety_${TIMESTAMP}.json"

        if [ -f "$PROJECT_ROOT/requirements.txt" ] || [ -f "$PROJECT_ROOT/setup.py" ] || [ -f "$PROJECT_ROOT/pyproject.toml" ]; then
            if safety check --json --output "$safety_report" 2>/dev/null; then
                print_success "Safety scan completed - No vulnerabilities found"
            else
                print_warning "Safety found dependency vulnerabilities - check $safety_report"
            fi
        else
            print_info "No Python dependency files found - skipping safety check"
        fi
    else
        print_warning "safety not installed - skipping dependency vulnerability check"
    fi
}

# Function to run YAML linting
run_yaml_scan() {
    print_info "Running YAML security and style checks..."

    if ! command_exists yamllint; then
        print_warning "yamllint not installed - skipping YAML validation"
        return 0
    fi

    local yaml_report="$REPORT_DIR/yamllint_${TIMESTAMP}.txt"

    if yamllint -c "$PROJECT_ROOT/.yamllint.yml" -f parsable "$PROJECT_ROOT" > "$yaml_report" 2>&1; then
        print_success "YAML lint completed - No issues found"
    else
        local issues_count=$(wc -l < "$yaml_report")
        print_warning "YAML lint found $issues_count issues - check $yaml_report"
    fi
}

# Function to run shell script security checks
run_shell_scan() {
    print_info "Running shell script security checks..."

    if ! command_exists shellcheck; then
        print_warning "shellcheck not installed - skipping shell script validation"
        return 0
    fi

    # Find shell scripts
    local shell_files
    shell_files=$(find "$PROJECT_ROOT" -name "*.sh" -not -path "$PROJECT_ROOT/.venv/*" -not -path "$PROJECT_ROOT/.git/*")

    if [ -z "$shell_files" ]; then
        print_warning "No shell scripts found to scan"
        return 0
    fi

    local shellcheck_report="$REPORT_DIR/shellcheck_${TIMESTAMP}.json"

    if echo "$shell_files" | xargs shellcheck --format=json > "$shellcheck_report" 2>&1; then
        print_success "Shellcheck completed - No issues found"
    else
        local issues_count=$(jq length "$shellcheck_report" 2>/dev/null || echo "unknown")
        print_warning "Shellcheck found $issues_count issues - check $shellcheck_report"
    fi
}

# Function to run Ansible security checks
run_ansible_scan() {
    print_info "Running Ansible security checks..."

    if ! command_exists ansible-lint; then
        print_warning "ansible-lint not installed - skipping Ansible validation"
        return 0
    fi

    local ansible_report="$REPORT_DIR/ansible-lint_${TIMESTAMP}.txt"

    if ansible-lint -c "$PROJECT_ROOT/.ansible-lint" "$PROJECT_ROOT" > "$ansible_report" 2>&1; then
        print_success "Ansible lint completed - No issues found"
    else
        local issues_count=$(grep -c "^TASK" "$ansible_report" 2>/dev/null || echo "unknown")
        print_warning "Ansible lint found $issues_count potential issues - check $ansible_report"
    fi
}

# Function to generate summary report
generate_summary() {
    local summary_file="$REPORT_DIR/security_summary_${TIMESTAMP}.txt"

    print_info "Generating security scan summary..."

    {
        echo "Security Scan Summary"
        echo "===================="
        echo "Timestamp: $(date)"
        echo "Project: $(basename "$PROJECT_ROOT")"
        echo "Reports Directory: $REPORT_DIR"
        echo ""

        echo "Scan Results:"
        echo "-------------"

        # Check each report type
        if [ -f "$REPORT_DIR/gitleaks_${TIMESTAMP}.json" ]; then
            local secrets_count=$(jq length "$REPORT_DIR/gitleaks_${TIMESTAMP}.json" 2>/dev/null || echo "unknown")
            echo "• Secrets Detection (gitleaks): $secrets_count potential secrets found"
        fi

        if [ -f "$REPORT_DIR/bandit_${TIMESTAMP}.json" ]; then
            local bandit_issues=$(jq '.results | length' "$REPORT_DIR/bandit_${TIMESTAMP}.json" 2>/dev/null || echo "unknown")
            echo "• Python Security (bandit): $bandit_issues issues found"
        fi

        if [ -f "$REPORT_DIR/safety_${TIMESTAMP}.json" ]; then
            echo "• Dependency Vulnerabilities (safety): Report generated"
        fi

        if [ -f "$REPORT_DIR/yamllint_${TIMESTAMP}.txt" ]; then
            local yaml_issues=$(wc -l < "$REPORT_DIR/yamllint_${TIMESTAMP}.txt")
            echo "• YAML Validation (yamllint): $yaml_issues issues found"
        fi

        if [ -f "$REPORT_DIR/shellcheck_${TIMESTAMP}.json" ]; then
            local shell_issues=$(jq length "$REPORT_DIR/shellcheck_${TIMESTAMP}.json" 2>/dev/null || echo "unknown")
            echo "• Shell Script Security (shellcheck): $shell_issues issues found"
        fi

        if [ -f "$REPORT_DIR/ansible-lint_${TIMESTAMP}.txt" ]; then
            echo "• Ansible Security (ansible-lint): Report generated"
        fi

        echo ""
        echo "Next Steps:"
        echo "-----------"
        echo "1. Review all reports in $REPORT_DIR"
        echo "2. Fix any high-priority security issues"
        echo "3. Consider running 'pre-commit run --all-files' to validate fixes"
        echo "4. Ensure no secrets are committed to version control"

    } > "$summary_file"

    print_success "Summary report generated: $summary_file"

    # Display summary to console
    echo ""
    cat "$summary_file"
}

# Main execution
main() {
    print_info "Starting comprehensive security scan..."
    print_info "Project directory: $PROJECT_ROOT"

    # Check if we're in a git repository
    if ! git -C "$PROJECT_ROOT" rev-parse --git-dir >/dev/null 2>&1; then
        print_warning "Not in a git repository - some scans may be limited"
    fi

    # Setup
    setup_report_dir

    # Run all scans (don't exit on individual failures)
    local overall_status=0

    run_gitleaks_scan || overall_status=1
    run_python_scans || true  # Don't fail on Python scan issues
    run_yaml_scan || true
    run_shell_scan || true
    run_ansible_scan || true

    # Generate summary
    generate_summary

    if [ $overall_status -eq 0 ]; then
        print_success "Security scan completed successfully!"
    else
        print_error "Security scan completed with issues - review reports"
    fi

    return $overall_status
}

# Handle command line arguments
case "${1:-}" in
    --help|-h)
        echo "Usage: $0 [OPTIONS]"
        echo ""
        echo "Run comprehensive security scans on the workstation provisioning project"
        echo ""
        echo "Options:"
        echo "  --help, -h     Show this help message"
        echo "  --clean        Remove old report files"
        echo ""
        echo "Reports are saved to: .security-reports/"
        exit 0
        ;;
    --clean)
        if [ -d "$REPORT_DIR" ]; then
            print_info "Cleaning old report files..."
            rm -rf "$REPORT_DIR"
            print_success "Report files cleaned"
        else
            print_info "No report files to clean"
        fi
        exit 0
        ;;
    "")
        main
        ;;
    *)
        print_error "Unknown option: $1"
        echo "Use --help for usage information"
        exit 1
        ;;
esac
