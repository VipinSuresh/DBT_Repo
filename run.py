import json
import logging
from dataclasses import dataclass
from typing import Optional
from urllib import parse
from urllib.request import Request, urlopen

from scripts.dbt.run_and_monitor_job.utils import configure_logger

# TODO(amir): create a base python image for `mfg-dbt` and install `rivian-common-fd-logging` in the base
# image; once we have our standard logging library, `utils.py` should be removed.
logger = logging.getLogger(
    name=__name__,
)
configure_logger(
    logger=logger,
)


@dataclass
class RunStatus:
    """Metadata of a running job.

    Parameters
    ----------
    account_id : str
        dbt account ID

    project_id : str
        Project ID

    run_id : int
        dbt job run ID

    Attributes
    ----------
    request_status_url : str
        Returns url for the status of the running job

    run_status_link : str
        Returns status link to the running job
    """

    account_id: Optional[str]
    project_id: Optional[str]
    run_id: int

    @property
    def request_status_url(self) -> str:
        """Returns url for the status of the running job.

        Returns
        -------
        str
        """
        return f"https://cloud.getdbt.com/api/v2/accounts/{self.account_id}/runs/{self.run_id}/"

    @property
    def run_status_link(self) -> str:
        """Returns status link to the running job.

        Returns
        -------
        str
        """
        return f"https://cloud.getdbt.com/#/accounts/{self.account_id}/projects/{self.project_id}/runs/{self.run_id}/"


def run_job(
    url: str,
    headers: dict[str, str],
    cause: Optional[str],
    branch: Optional[str],
) -> int:
    """Runs a dbt job and returns the `job_id` of the run.

    Parameters
    ----------
    url : str
        Request job url

    headers : dict[str, str]
        Request auth headers

    cause : str
        dbt job causes

    branch : str
        dbt job git-branch

    Returns
    -------
    int
    """

    request_payload: dict[str, Optional[str]] = {
        "cause": cause,
    }
    if branch and not branch.startswith("$("):
        # valid git-branches should not start with '$('
        request_payload["git_branch"] = branch.replace("refs/heads/", "")

    logger.info(
        f"Triggering job:\n\turl: {url}\n\tpayload: {request_payload}",
    )
    data = parse.urlencode(request_payload).encode()
    request = Request(
        method="POST",
        data=data,
        headers=headers,
        url=url,
    )
    with urlopen(request) as req:
        response = req.read().decode("utf-8")
        run_job_response = json.loads(response)

    return run_job_response["data"]["id"]


def get_run_status(url: str, headers: dict[str, str]) -> str:
    """Returns the status of a running dbt job.

    Parameters
    ----------
    url : str
        Request job url

    headers : dict[str, str]
        Request auth headers

    Returns
    -------
    str
    """
    request = Request(
        headers=headers,
        url=url,
    )
    with urlopen(request) as req:
        response = req.read().decode("utf-8")
        req_status_response = json.loads(response)

    run_status_code = req_status_response["data"]["status"]
    run_status_map = _run_status_map()

    if run_status_code not in run_status_map:
        raise ValueError(
            f"{run_status_code=} could not be found in the current {run_status_map=} ...",
        )

    return run_status_map[run_status_code]


def _run_status_map() -> dict[int, str]:
    """dbt run statuses are encoded as integers. This map provides a human-readable status.

    Returns
    -------
    dict[int, str]
    """
    return {
        1: "Queued",
        2: "Starting",
        3: "Running",
        10: "Success",
        20: "Error",
        30: "Cancelled",
    }
