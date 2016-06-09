#!/bin/sh
_OUT=dist/simon.love
zip -9 -q -r ${_OUT} . && echo "created ${_OUT}"
du -sh ${_OUT}
