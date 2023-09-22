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

# Fundamental

INSTANCENAME=NCv999_nam_be # "name" of this ASGS process
ASGSADMIN="asgsnotify@memenesia.net"
ASGSADMIN_ID=be

# Input files and templates

GRIDNAME=NCv999

source $SCRIPTDIR/config/mesh_defaults.sh

# Physical forcing (defaults set in config/forcing_defaults.sh)

TIDEFAC=on               # tide factor recalc
   HINDCASTLENGTH=20.0   # length of initial hindcast, from cold (days)
BACKGROUNDMET=namBlend   # GFS download/forcing
   FORECASTCYCLE="00,06,12,18"
TROPICALCYCLONE=on       # tropical cyclone forcing
   STORM=16              # storm number, e.g. 05=ernesto in 2006
   YEAR=2023             # year of the storm
WAVES=on                 # wave forcing
   REINITIALIZESWAN=no   # used to bounce the wave solution
VARFLUX=default          # variable river flux forcing
#
CYCLETIMELIMIT="99:00:00"

# Computational Resources (related defaults set in platforms.sh)

NCPU=479                # number of compute CPUs for all simulations
NCPUCAPACITY=9999
NUMWRITERS=1

# Post processing and publication

INTENDEDAUDIENCE=general    # "general" | "developers-only" | "professional"
OPENDAPPOST=opendap_post2.sh
POSTPROCESS=( includeWind10m.sh createOPeNDAPFileList.sh $OPENDAPPOST )
OPENDAPNOTIFY="coastalrisk.live@outlook.com,pub.coastalrisk.live@outlook.com,jason.fleming@seahorsecoastal.com,jason.fleming@stormsurge.live,asgsnotify@memenesia.net"
hooksScripts[FINISH_SPINUP_SCENARIO]=" output/createOPeNDAPFileList.sh output/$OPENDAPPOST "
hooksScripts[FINISH_NOWCAST_SCENARIO]=" output/createOPeNDAPFileList.sh output/$OPENDAPPOST "
TDS=( lsu_tds )

# Monitoring

enablePostStatus="yes"
enableStatusNotify="no"
statusNotify="null"

# Initial state (overridden by STATEFILE after ASGS gets going)

COLDSTARTDATE=2023082000
HOTORCOLD=hotstart
HOTSTARTFORMAT=netcdf3
LASTSUBDIR=http://chg-1.oden.tacc.utexas.edu/thredds/fileServer/asgs/2023/nam/2023092112/NCv999/frontera.tacc.utexas.edu/NCv999_nam_jgf/namforecast

#
# Scenario package
#
#PERCENT=default
SCENARIOPACKAGESIZE=6
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
    2)
       ENSTORM=veerRight100Wind10m
       PERCENT=100
       ;;
    3)
       ENSTORM=veerRight100
       PERCENT=100
       ;;
    4)
       ENSTORM=veerLeft100Wind10m
       PERCENT=-100
       ;;
    5)
       ENSTORM=veerLeft100
       PERCENT=-100
       ;;
    *)
       echo "CONFIGURATION ERROR: Unknown ensemble member number: '$si'."
      ;;
esac

source $SCRIPTDIR/config/io_defaults.sh # sets met-only mode based on "Wind10m" suffix
PREPPEDARCHIVE=prepped_${GRIDNAME}_${INSTANCENAME}_${NCPU}.tar.gz
HINDCASTARCHIVE=prepped_${GRIDNAME}_hc_${INSTANCENAME}_${NCPU}.tar.gz
