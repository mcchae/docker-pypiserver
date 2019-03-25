#!/bin/bash

PYPI_ROOT="${PYPI_ROOT:-/pypi}"
PYPI_PORT=${PYPI_PORT:-80}
PYPI_PASSWD_FILE="${PYPI_PASSWD_FILE:-${PYPI_ROOT}/.htpasswd}"
PYPI_AUTHENTICATE="${PYPI_AUTHENTICATE:-update}"

# make sure the passwd file exists
touch "${PYPI_PASSWD_FILE}"

_extra="${PYPI_EXTRA}"

# allow existing packages to be overwritten
if [[ "${PYPI_OVERWRITE}" != "" ]]; then
    _extra="${_extra} --overwrite"
fi

exec /usr/local/bin/pypi-server \
    --port ${PYPI_PORT} \
    --passwords "${PYPI_PASSWD_FILE}" \
    --authenticate "${PYPI_AUTHENTICATE}" \
    ${_extra} \
    "${PYPI_ROOT}"
