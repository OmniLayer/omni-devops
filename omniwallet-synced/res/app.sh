#!/bin/bash

kill_child_processes() {
	kill $SERVER_PID
	rm -f $LOCK_FILE
}

# Ctrl-C trap. Catches INT signal
trap "kill_child_processes 1 $$; exit 0" INT
echo "Starting app.sh: $(TZ='America/Chicago' date)"

echo "Establishing environment variables..."
APPDIR=`pwd`
TOOLSDIR=$APPDIR
DATADIR="/var/lib/mastercoin-tools"
LOCK_FILE=$DATADIR/msc_cron.lock
PARSE_LOG=$DATADIR/parsed.log
VALIDATE_LOG=$DATADIR/validated.log
ARCHIVE_LOG=$DATADIR/archived.log

mkdir -p $DATADIR
# Export directories for API scripts to use
export TOOLSDIR
export DATADIR

if [ ! -d $DATADIR/tx ]; then
        cp -r $TOOLSDIR/www/tx $DATADIR/tx
fi

cd $DATADIR
mkdir -p tmptx tx addr general offers wallets sessions mastercoin_verify/addresses mastercoin_verify/transactions www
SERVER_PID=$!

if [ "$1" = "-status" ]; then
    cat $DATADIR/www/revision.json | cut -d"," -f3
    cat $DATADIR/www/revision.json | cut -d"," -f4
    exit
fi

echo "Beginning main run loop..."
while true
do

	# check lock (not to run multiple times)
	if [ ! -f $LOCK_FILE ]; then

		#mkdir -p $DATADIR
		#cd $DATADIR
		#mkdir -p tmptx tx addr general offers wallets sessions mastercoin_verify/addresses mastercoin_verify/transactions www

		# lock
		touch $LOCK_FILE

		# parse until full success
		x=1 # assume failure
		echo -n > $PARSE_LOG

		while [ "$x" != "0" ];
		do
      		echo "Parsing last block $(cat www/revision.json | cut -b 102-109) at $(TZ='America/Chicago' date)"
			python $TOOLSDIR/msc_parse.py -r $TOOLSDIR 2>&1 >> $PARSE_LOG
  			x=$?
		done

		echo "Running validation step..."
		python $TOOLSDIR/msc_validate.py 2>&1 > $VALIDATE_LOG

#		echo "Getting price calculation..."
#		mkdir -p $DATADIR/www/values $DATADIR/www/values/history
#		python $APPDIR/api/coin_values.py

		# update archive
		echo "Running archive tool..."
		python $TOOLSDIR/msc_archive.py -r $TOOLSDIR 2>&1 > $ARCHIVE_LOG

		mkdir -p $DATADIR/www/tx $DATADIR/www/addr $DATADIR/www/general $DATADIR/www/offers $DATADIR/www/mastercoin_verify/addresses $DATADIR/www/mastercoin_verify/transactions

		echo "Copying data back to /www/ folder..."
		find $DATADIR/tx/. -name "*.json" | xargs -I % cp -rp % $DATADIR/www/tx
		find $DATADIR/addr/. -name "*.json" | xargs -I % cp -rp % $DATADIR/www/addr
		find $DATADIR/general/. -name "*.json" | xargs -I % cp -rp % $DATADIR/www/general
		find $DATADIR/offers/. -name "*.json" | xargs -I % cp -rp % $DATADIR/www/offers
		find $DATADIR/mastercoin_verify/addresses/. | xargs -I % cp -rp % $DATADIR/www/mastercoin_verify/addresses
		find $DATADIR/mastercoin_verify/transactions/. | xargs -I % cp -rp % $DATADIR/www/mastercoin_verify/transactions

		# unlock
		rm -f $LOCK_FILE
	fi

	# Wait a minute, and do it all again.
	echo "Done, sleeping..."
	sleep 60
done
