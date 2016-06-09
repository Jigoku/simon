#!/bin/sh
_OUT=dist/simon.love
rm ${_OUT}
zip -9 -q -r -v --exclude=*.git* ${_OUT} . && echo "created ${_OUT}"
du -sh ${_OUT}
