#!/bin/sh
#-------------------------------------------------------------------
# config.sh: This file is read at the beginning of the execution of the ASGS to
# set up the runs  that follow. It is reread at the beginning of every cycle,
# every time it polls the datasource for a new advisory. This gives the user
# the opportunity to edit this file mid-storm to change config parameters
# (e.g., the name of the queue to submit to, the addresses on the mailing list,
# etc)
#-------------------------------------------------------------------
#
# Copyright(C) 2020 Jason Fleming
#
# This file is part of the ADCIRC Surge Guidance System (ASGS).
#
# The ASGS is free software: you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# ASGS is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# the ASGS.  If not, see <http://www.gnu.org/licenses/>.
#-------------------------------------------------------------------

# Fundamental
## "ACCOUNT" set in $HOME/.asgsh_profile

INSTANCENAME=TX2008-replay-ls6
ASGSADMIN="asgsnotifications@opayq.com"

# check ~/.asgsh_profile for setting of "ACCOUNT"
QUEUENAME=normal
SERQUEUE=normal
PPN=128

# ADCIRC related
NSCREEN=-1000

HOTORCOLD=coldstart

# Input files and templates
GRIDNAME=TX2008
source $SCRIPTDIR/config/mesh_defaults.sh

#-- gustav configurations generated by StormReplay.com WebUI --#
BACKGROUNDMET=off
TROPICALCYCLONE=on
  STORM=07
  YEAR=2023
  STARTADV=1
  ENDADV=35
TRIGGER=rssembedded # required mode
  FTPSITE=stormreplay.com
  HDIR=/atcf/btk/82AaeD2EOWvgjZ6fKYaXXHuSxwyh1Q04
  RSSSITE=stormreplay.com:443/rss/82AaeD2EOWvgjZ6fKYaXXHuSxwyh1Q04
COLDSTARTDATE=2023032218
HINDCASTLENGTH=30.0
WAVES=off
CYCLETIMELIMIT="99:00:00"
#-- gustav configurations generated by StormReplay.com WebUI --#
OPENDAPADDROOT=READINESS-DRILL-2023

# Computational Resources (related defaults set in platforms.sh)
NCPU=959     # number of compute CPUs for all simulations
NUMWRITERS=1
NCPUCAPACITY=9999

# Post processing and publication
EMAILNOTIFY=yes
INTENDEDAUDIENCE=developers-only    # "general" | "developers-only" | "professional"
OPENDAPADDROOT=replay-test
OPENDAPPOST=opendap_post2.sh
postAdditionalFiles=( /tmp/file1.ext /tmp/file2.ext /tmp/fileN.etc )
POSTPROCESS=( createMaxCSV.sh includeWind10m.sh createOPeNDAPFileList.sh $OPENDAPPOST )
OPENDAPNOTIFY="asgsnotifications@opayq.com"
NOTIFY_SCRIPT=cera_notify.sh
TDS=( tacc_tds3 )

# Initial state (overridden by STATEFILE after ASGS gets going)
LASTSUBDIR=null
#
# Scenario package
#
PERCENT=default
SCENARIOPACKAGESIZE=2
case $si in
   -2)
       ENSTORM=hindcast
       ;;
   -1)
       # do nothing ... this is not a forecast
       ENSTORM=nowcast
       ;;
    0)
       ENSTORM=nhcConsensusWind10m
       ;;
    1)
       ENSTORM=nhcConsensus
       ;;
    *)
       echo "CONFIGRATION ERROR: Unknown ensemble member number: '$si'."
      ;;
esac
source $SCRIPTDIR/config/io_defaults.sh # sets met-only mode based on "Wind10m" suffix
PREPPEDARCHIVE=prepped_${GRIDNAME}_${INSTANCENAME}_${NCPU}.tar.gz
HINDCASTARCHIVE=prepped_${GRIDNAME}_hc_${INSTANCENAME}_${NCPU}.tar.gz
