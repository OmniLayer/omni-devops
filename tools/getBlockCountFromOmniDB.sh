#!/bin/sh
psql omniwallet <<ENDEND
select max(blocknumber) from blocks
ENDEND

