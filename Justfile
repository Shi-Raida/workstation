default: run

# run an ansible task
run TASK="tasks/main.yml":
    ./run.sh {{ TASK }}
