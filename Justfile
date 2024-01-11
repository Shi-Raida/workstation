# Use with https://github.com/casey/just

@_default:
    just --list

# Run an ansible task
run TASK="tasks/main.yml":
    ./run.sh {{ TASK }}
