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
# Copyright(C) 2023 Jason Fleming
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
# The defaults for parameters that can be reset in this config file
# are preset in the following scripts:
# {SCRIPTDIR/platforms.sh               # also contains Operator-specific info
# {SCRIPTDIR/config/config_defaults.sh
# {SCRIPTDIR/config/mesh_defaults.sh
# {SCRIPTDIR/config/forcing_defaults.sh
# {SCRIPTDIR/config/io_defaults.sh
# {SCRIPTDIR/config/operator_defaults.sh
#-------------------------------------------------------------------

# Fundamental

INSTANCENAME=EGOMv20b_al102023_jgf   # "name" of this ASGS process

# Input files and templates

GRIDNAME=EGOMv20b
source $SCRIPTDIR/config/mesh_defaults.sh
HOTSTARTFORMAT=netcdf3

# Physical forcing (defaults set in config/forcing_defaults)

TIDEFAC=on              # tide factor recalc
HINDCASTLENGTH=30.0     # length of initial hindcast, from cold (days)
BACKGROUNDMET=off       # NAM download/forcing
FORECASTCYCLE="00,06,12,18"
TROPICALCYCLONE=on      # tropical cyclone forcing
STORM=10                # storm number, e.g. 05=ernesto in 2006
YEAR=2023               # year of the storm
WAVES=on                # wave forcing
REINITIALIZESWAN=no     # used to bounce the wave solution
VARFLUX=off             # variable river flux forcing
CYCLETIMELIMIT="99:00:00"

# Computational Resources (related defaults set in platforms.sh)

NCPU=959                     # number of compute CPUs for all simulations
NUMWRITERS=1
NCPUCAPACITY=9999

# Post processing and publication

INTENDEDAUDIENCE=general    # can also be "developers-only" or "professional"
OPENDAPPOST=opendap_post2.sh
POSTPROCESS=( includeWind10m.sh createOPeNDAPFileList.sh $OPENDAPPOST )
OPENDAPNOTIFY="coastalrisk.live@outlook.com,pub.coastalrisk.live@outlook.com,jason.fleming@seahorsecoastal.com,jason.fleming@stormsurge.live"
hooksScripts[FINISH_SPINUP_SCENARIO]=" output/createOPeNDAPFileList.sh output/$OPENDAPPOST "
hooksScripts[FINISH_NOWCAST_SCENARIO]=" output/createOPeNDAPFileList.sh output/$OPENDAPPOST "

# Monitoring

enablePostStatus="yes"
enableStatusNotify="no"
statusNotify="null"

# Initial state (overridden by STATEFILE after ASGS gets going)

COLDSTARTDATE=auto
HOTORCOLD=hotstart      # "hotstart" or "coldstart"
LASTSUBDIR=https://fortytwo.cct.lsu.edu/thredds/fileServer/2023/nam/2023082618/EGOMv20b/supermic.hpc.lsu.edu/EGOMv20b_nam_jgf/namforecast

# Scenario package

#PERCENT=default
SCENARIOPACKAGESIZE=6 # <====<<!!TWO TOTAL!! # number of scenarios
case $si in
 -2)
   ENSTORM=hindcast
   OPENDAPNOTIFY="null"
   ;;
-1)
   # do nothing ... this is not a forecast
   ENSTORM=nowcast
   OPENDAPNOTIFY="null"
   ;;
0)
   ENSTORM=nhcConsensusWind10m
   source $SCRIPTDIR/config/io_defaults.sh # sets met-only mode based on "Wind10m" suffix
   ;;
1)
   ENSTORM=nhcConsensus
   ;;
2)
   ENSTORM=veerRight100Wind10m
   PERCENT=100
   source $SCRIPTDIR/config/io_defaults.sh # sets met-only mode based on "Wind10m" suffix
   ;;
3)
   ENSTORM=veerRight100
   PERCENT=100
   ;;
4)
   ENSTORM=veerLeft100Wind10m
   PERCENT=-100
   source $SCRIPTDIR/config/io_defaults.sh # sets met-only mode based on "Wind10m" suffix
   ;;
5)
   ENSTORM=veerLeft100
   PERCENT=-100
   ;;
*)
   echo "CONFIGRATION ERROR: Unknown scenario number: '$si'."
   ;;
esac

PREPPEDARCHIVE=prepped_${GRIDNAME}_${INSTANCENAME}_${NCPU}.tar.gz
HINDCASTARCHIVE=prepped_${GRIDNAME}_hc_${INSTANCENAME}_${NCPU}.tar.gz
