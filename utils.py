import logging
import sys


# TODO(amir): create a base python image for `mfg-dbt` and install `companyname-common-fd-logging` in the base
# image; once we have our standard logging library, `utils.py` should be removed.
def configure_logger(logger: logging.Logger) -> None:
    """Configures the given logger with custom formatting.

    Returns
    -------
    None
    """
    logger.setLevel(
        level=logging.INFO,
    )
    stream_handler = logging.StreamHandler(sys.stdout)
    formatter = logging.Formatter(
        "%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    )
    stream_handler.setFormatter(formatter)
    logger.addHandler(stream_handler)

    return None
