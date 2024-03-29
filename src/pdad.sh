#!/bin/bash

###############################################################################
#
#	pdad.sh
#
#	A small daemon that periodically sweeps an input directory,
#	looking for input files (employees CSV data) to process.
#	Uses the conv and app applications to this end.
#
#	Created at:
#		2012-01-11
#
#	Author(s):
#
#		B5-8 LAPRIII group
#
###############################################################################

PDAD_HOME=`pwd`
BIN_DIR=$PDAD_HOME
INPUT_DIR=../tests
OUTPUT_DIR=$PDAD_HOME
SAVE_DIR=$OUTPUT_DIR
LOG_FILE=$OUTPUT_DIR/pdad_log
SLEEP=1

while [[ 1 -eq 1 ]]
do
	sleep($SLEEP)
	
	file_list=`ls $INPUT_DIR/*.csv`
	for file in $file_list
	do
		out_file=$OUTPUT_DIR/$file_`date +%Y-%m-%d`.bin
		$BIN_DIR/conv $file $out_file
		RET=$?
		
		if [[ $RET -ne 0 ]]
		then
			echo "conv failed for file $file" >> pdad_log_`date +%Y%m%d_%H%M%S`
		else
			mv $file $SAVE_DIR
		fi
		
		$BIN_DIR/app $out_file
		RET=$?
		
		if [[ $RET -ne 0 ]]
		then
			echo "app failed for file $out_file" >> pdad_log_`date +%Y%m%d_%H%M%S`
		fi
	done
done