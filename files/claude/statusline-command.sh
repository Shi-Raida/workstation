#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract values from JSON
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
model_display_name=$(echo "$input" | jq -r '.model.display_name')

# Extract token information
exceeds_200k=$(echo "$input" | jq -r '.exceeds_200k_tokens // false')
token_count=$(echo "$input" | jq -r '.token_count // 0')
input_tokens=$(echo "$input" | jq -r '.input_tokens // 0')
output_tokens=$(echo "$input" | jq -r '.output_tokens // 0')

# Get basename of current directory
dir_name=$(basename "$current_dir")

# Check if we're in a git repository and get branch name with status
git_info=""
if git -C "$current_dir" rev-parse --git-dir >/dev/null 2>&1; then
    branch=$(git -C "$current_dir" branch --show-current 2>/dev/null)
    if [ -n "$branch" ]; then
        # Get git status information
        status_indicators=""

        # Check for stashed changes ($) - put first
        if [ -n "$(git -C "$current_dir" stash list 2>/dev/null)" ]; then
            status_indicators="${status_indicators}$"
        fi

        # Check for unstaged changes (!)
        if ! git -C "$current_dir" diff --quiet 2>/dev/null; then
            status_indicators="${status_indicators}!"
        fi

        # Check for staged changes (+)
        if ! git -C "$current_dir" diff --cached --quiet 2>/dev/null; then
            status_indicators="${status_indicators}+"
        fi

        # Check for untracked files (?)
        if [ -n "$(git -C "$current_dir" ls-files --others --exclude-standard 2>/dev/null)" ]; then
            status_indicators="${status_indicators}?"
        fi

        # Check upstream status (ahead/behind/diverged)
        upstream=$(git -C "$current_dir" rev-parse --abbrev-ref '@{upstream}' 2>/dev/null)
        if [ -n "$upstream" ]; then
            ahead=$(git -C "$current_dir" rev-list --count 'HEAD..@{upstream}' 2>/dev/null)
            behind=$(git -C "$current_dir" rev-list --count '@{upstream}..HEAD' 2>/dev/null)

            if [ "$ahead" -gt 0 ] && [ "$behind" -gt 0 ]; then
                status_indicators="${status_indicators}⇕"
            elif [ "$ahead" -gt 0 ]; then
                status_indicators="${status_indicators}⇣"
            elif [ "$behind" -gt 0 ]; then
                status_indicators="${status_indicators}⇡"
            fi
        fi

        # Build status string with brackets if there are indicators
        if [ -n "$status_indicators" ]; then
            git_info="$branch"
            git_status=" [$status_indicators]"
        else
            git_info="$branch"
            git_status=""
        fi
    fi
fi

# Build token display with color coding
token_display=""
if [ "$token_count" != "0" ] || [ "$input_tokens" != "0" ] || [ "$output_tokens" != "0" ]; then
    # Calculate total tokens (prefer token_count if available, otherwise sum input+output)
    if [ "$token_count" != "0" ]; then
        total_tokens="$token_count"
    else
        total_tokens=$((input_tokens + output_tokens))
    fi

    # Format token count (k for thousands)
    if [ "$total_tokens" -gt 999 ]; then
        formatted_tokens=$(echo "scale=1; $total_tokens / 1000" | bc)k
    else
        formatted_tokens="$total_tokens"
    fi

    # Color coding based on token usage
    if [ "$exceeds_200k" = "true" ] || [ "$total_tokens" -gt 180000 ]; then
        # Red for danger zone (>180k or exceeds limit)
        token_display="📊 \033[1;31m🔴 ${formatted_tokens}\033[0m"
    elif [ "$total_tokens" -gt 100000 ]; then
        # Yellow for warning zone (100k-180k)
        token_display="📊 \033[1;33m⚠️  ${formatted_tokens}\033[0m"
    else
        # Green for safe zone (<100k)
        token_display="📊 \033[1;32m${formatted_tokens}\033[0m"
    fi
fi

# Build the status line using printf with Starship-inspired colors
if [ -n "$git_info" ]; then
    if [ -n "$git_status" ]; then
        if [ -n "$token_display" ]; then
            printf "\033[1;38;5;84m%s\033[0m on \033[1;38;5;212m %s\033[0m\033[1;38;5;167m%s\033[0m | %s | %s" \
                "$dir_name" \
                "$git_info" \
                "$git_status" \
                "$token_display" \
                "$model_display_name"
        else
            printf "\033[1;38;5;84m%s\033[0m on \033[1;38;5;212m %s\033[0m\033[1;38;5;167m%s\033[0m | %s" \
                "$dir_name" \
                "$git_info" \
                "$git_status" \
                "$model_display_name"
        fi
    else
        if [ -n "$token_display" ]; then
            printf "\033[1;38;5;84m%s\033[0m on \033[1;38;5;212m %s\033[0m | %s | %s" \
                "$dir_name" \
                "$git_info" \
                "$token_display" \
                "$model_display_name"
        else
            printf "\033[1;38;5;84m%s\033[0m on \033[1;38;5;212m %s\033[0m | %s" \
                "$dir_name" \
                "$git_info" \
                "$model_display_name"
        fi
    fi
else
    if [ -n "$token_display" ]; then
        printf "\033[1;38;5;84m%s\033[0m | %s | %s" \
            "$dir_name" \
            "$token_display" \
            "$model_display_name"
    else
        printf "\033[1;38;5;84m%s\033[0m | %s" \
            "$dir_name" \
            "$model_display_name"
    fi
fi
