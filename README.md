# Scripts

The `scripts/` directory contains scripts for automating tasks, e.g. running and monitoring `dbt` jobs as `CI` steps.

Note:
- `scripts` can be language agnostic and depends on the `image` you are using in `CI`.
- In `CI` first the `mfg-dbt` repository gets checked out and you will be in the `root` of the project. The best practice is to run all `scripts/` from `root` and adapt the `path` in case you have multiple files in your script. This is very important for some languages including `python` in which the `PATH` is almost alawys wrong. Additionally, it is recommended to run the `python` scripts as `module` using `python -m` to minimize the chance of using a wrong `PATH` for python executables.
- Currently, the `scripts/` are designed to be executed as part of `CI`. However, we plan to add the `CLI` functionalities for all `scripts/` so `dbt admins` can pass requried params as `--key=value`, and directly run their desired `scripts/` from `command-line terminal` rather opening up a `merge-request`. This feature would enable the `dbt admins` to run `ANY` specific `job-id` when `debugging`.

## dbt

Scripts for automating dbt cloud tasks.

### run_and_monitor_job

The run_and_monitor_job python script (adopted from [dbt docs](https://docs.getdbt.com/guides/orchestration/custom-cicd-pipelines/3-dbt-cloud-job-on-merge#3-create-script-to-trigger-dbt-cloud-job-via-an-api-call)) can be used for any pipeline job that needs to trigger a dbt cloud job.

Note:
- Currently, the required parameters for  `run_and_monitor_job` are being invoked as `environment-variables`; we plan to add the `CLI` functionality as well.
- At run-time, run_and_monitor scripts will use the following `environment-variables`: `DBT_ACCOUNT_ID`, `DBT_PROJECT_ID`, `DBT_API_KEY`, `DBT_JOB_BRANCH`, `DBT_MR_JOB_ID`, `DBT_JOB_CAUSE`. For more details, please see [scripts/dbt/run_and_monitor_job/config.py](https://gitlab.com/rivian/me/factory-data/mfg-dbt/-/tree/main/scripts/dbt/run_and_monitor_job/config.py).
- In order to run, you can add the following command to the `script` of a `.gitlab-ci.yml` job:

  ```yaml
  script:
    - python -m scripts.dbt.run_and_monitor_job.__main__
  ```


