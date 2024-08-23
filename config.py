import os
from dataclasses import dataclass
from typing import Any, Optional


@dataclass
class Config:
    """Configuration parameters to run/monitor of a dbt job.

    Parameters
    ----------
    account_id : str, optional
        dbt account ID, by default None

    project_id : str, optional
        Project ID, by default None

    api_key : str, optional
        dbt API key, by default None

    job_id : str, optional
        dbt job ID, by default None

    git_branch : str, optional
        dbt job branch, by default None

    job_cause : str, optional
        dbt job cause, by default None

    Notes
    -----
    All config parameters using the available environment variables are first being validated. The
    environment variables `DBT_ACCOUNT_ID`, `DBT_PROJECT_ID`, `DBT_API_KEY`, `DBT_MR_JOB_ID` should
    always be available in the environment and in their absence `ValueError` exception will be thrown.

    Raises
    ------
    ValueError
    """

    account_id: Optional[str] = None
    project_id: Optional[str] = None
    api_key: Optional[str] = None
    job_id: Optional[str] = None
    git_branch: Optional[str] = None
    job_cause: Optional[str] = None

    def __post_init__(self) -> None:
        """Post init validation."""
        self._validate()

    @property
    def request_auth_header(self) -> dict[str, str]:
        """Request header for auth.

        Returns
        -------
        dict[str, str]
        """
        return {
            "Authorization": f"Token {self.api_key}",
        }

    @property
    def request_job_url(self) -> str:
        """Request job url.

        Returns
        -------
        str
        """
        return f"https://cloud.getdbt.com/api/v2/accounts/{self.account_id}/jobs/{self.job_id}/run/"

    def _validate(self) -> None:
        """Validates all config parameters using the available environment variables.

        Returns
        -------
        None

        Raises
        ------
        ValueError
        """
        self.account_id = self._check_env_var(
            self.account_id,
            env_var_name="DBT_ACCOUNT_ID",
            default_value=None,
        )
        self.project_id = self._check_env_var(
            self.project_id,
            env_var_name="DBT_PROJECT_ID",
            default_value=None,
        )
        self.api_key = self._check_env_var(
            self.api_key,
            env_var_name="DBT_API_KEY",
            default_value=None,
        )
        self.job_id = self._check_env_var(
            self.job_id,
            env_var_name="DBT_MR_JOB_ID",
            default_value=None,
        )
        self.git_branch = self._check_env_var(
            self.git_branch,
            env_var_name="DBT_JOB_BRANCH",
            default_value=None,
        )
        self.job_cause = self._check_env_var(
            self.job_cause,
            env_var_name="DBT_JOB_CAUSE",
            default_value="API-triggered job",
        )

    # TODO(amir): currently, we are only enabling the invocation of requried run-time params from env-vars
    # while the params can be passed directly to `Config()` class directly. Currently, the user needs to
    # update the entrypoint of the script (`__main__.py`) in case of any ad-hoc run; The best way is to enable
    # CLI functionalities using `argparse` (does not need to be installed) or (`click` or `typer`) (should be installed)
    # The requrired libraries can be installed in the base python image for `dbt` project
    @staticmethod
    def _check_env_var(
        var: Any,
        *,
        env_var_name: str,
        default_value: Optional[str],
    ) -> Any:
        """Returns validated variables with available environment variables.

        Parameters
        ----------
        var : Any
            Config variable

        env_var_name : str
            Environment variable name

        default_value : str
            Default value to be set for environment variable

        Raises
        ------
        ValueError

        Returns
        -------
        Any
        """
        ret = None
        if var is None:
            if env_var_name in {"DBT_JOB_BRANCH"}:
                ret = None
            else:
                _var = os.getenv(env_var_name, default_value)
                if _var is None:
                    raise ValueError(
                        f"Environment variable `{env_var_name}` could not be found.",
                    )
                else:
                    ret = _var
        else:
            ret = var

        return ret
