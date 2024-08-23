import logging
import time

from scripts.dbt.run_and_monitor_job.config import Config
from scripts.dbt.run_and_monitor_job.run import RunStatus, get_run_status, run_job
from scripts.dbt.run_and_monitor_job.utils import configure_logger

# TODO(amir): create a base python image for `mfg-dbt` and install `companyname-common-fd-logging` in the base
# image; once we have our standard logging library, `utils.py` should be removed
logger = logging.getLogger(
    name=__name__,
)
configure_logger(
    logger=logger,
)


# TODO(amir): currently, we are only enabling the invocation of required run-time params from env-vars
# while the params can be passed directly to `Config()` class directly. Currently, the user needs to
# update the entrypoint of the script (`__main__.py`) in case of any ad-hoc run; The best way is to enable
# CLI functionalities using `argparse` (does not need to be installed) or (`click` or `typer`) (should be installed)
# The required libraries can be installed in the base python image for `dbt` project
def main() -> int:
    """Main entry point for run_and_monitor_job.

    Notes
    -----
    The run_and_monitor_job script (adopted from dbt docs [1]_) can be used for any pipeline job that needs
    to trigger a dbt cloud job.

    References
    ----------
    .. [1] https://docs.getdbt.com/guides/orchestration/custom-cicd-pipelines/3-dbt-cloud-job-on-merge#3-create-script-to-trigger-dbt-cloud-job-via-an-api-call

    Returns
    -------
    int
    """
    logger.info(
        "Beginning request for job run ...",
    )

    # TODO(amir): get configs params from `CLI` in addition to `env-vars`
    cfg = Config()
    logger.info(
        f"Job Configurations ...\n{cfg}",
    )

    try:
        run_id = run_job(
            url=cfg.request_job_url,
            headers=cfg.request_auth_header,
            cause=cfg.job_cause,
            branch=cfg.git_branch,
        )
    except Exception as e:
        logger.error(
            f"ERROR! - Could not trigger job:\n {e}",
        )
        raise

    run_status = RunStatus(
        account_id=cfg.account_id,
        project_id=cfg.project_id,
        run_id=run_id,
    )
    logger.info(
        f"Job running! See job status at {run_status.run_status_link}",
    )

    time.sleep(30)
    while True:
        status = get_run_status(
            url=run_status.request_status_url,
            headers=cfg.request_auth_header,
        )
        logger.info(
            f"Run status -> {status}",
        )

        if status in {"Error", "Cancelled"}:
            raise Exception(
                f"Run failed or canceled! See why at {run_status.run_status_link}",
            )

        if status == "Success":
            logger.info(
                f"Job completed successfully! See details at {run_status.run_status_link}",
            )
            return 0

        time.sleep(10)


if __name__ == "__main__":
    raise SystemExit(main())
