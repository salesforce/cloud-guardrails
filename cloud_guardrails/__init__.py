# pylint: disable=missing-module-docstring
import logging
from logging import NullHandler

# Set default handler when cloud_guardrails is used as library to avoid "No handler found" warnings.
logging.getLogger(__name__).addHandler(NullHandler())


def set_stream_logger(name="cloud_guardrails", level=logging.DEBUG, format_string=None):
    """
    Add a stream handler for the given name and level to the logging module.
    By default, this logs all cloud_guardrails messages to ``stdout``.
        >>> import cloud_guardrails
        >>> cloud_guardrails.set_stream_logger('cloud_guardrails.database.build', logging.INFO)
    :type name: string
    :param name: Log name
    :type level: int
    :param level: Logging level, e.g. ``logging.INFO``
    :type format_string: str
    :param format_string: Log message format
    """
    # remove existing handlers. since NullHandler is added by default
    handlers = logging.getLogger(name).handlers
    for handler in handlers:
        logging.getLogger(name).removeHandler(handler)
    if format_string is None:
        format_string = "%(asctime)s %(name)s [%(levelname)s] %(message)s"
    logger = logging.getLogger(name)
    logger.setLevel(level)
    handler = logging.StreamHandler()
    handler.setLevel(level)
    formatter = logging.Formatter(format_string)
    handler.setFormatter(formatter)
    logger.addHandler(handler)


def set_log_level(verbose):
    """
    Set Log Level based on click's count argument.

    Default log level to critical; otherwise, set to: warning for -v, info for -vv, debug for -vvv

    :param verbose: integer for verbosity count.
    :return:
    """
    if verbose == 1:
        set_stream_logger(level=getattr(logging, "WARNING"))
    elif verbose == 2:
        set_stream_logger(level=getattr(logging, "INFO"))
    elif verbose >= 3:
        set_stream_logger(level=getattr(logging, "DEBUG"))
    else:
        set_stream_logger(level=getattr(logging, "CRITICAL"))


def set_log_format_to_simple_warning(name: str, level : int = logging.WARNING):
    """A basic wrapper around set_stream_logger that sets the log formatter to a simple formatted warning"""
    format_string = "[%(levelname)s] %(message)s"
    set_stream_logger(name=name, level=level, format_string=format_string)
