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
# Copyright(C) 2019 Jason Fleming
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

INSTANCENAME=ncfs-dev-ncv99-al05-master      # "name" of this ASGS process
SCRATCHDIR=/scratch/ncfs-dev/${INSTANCENAME}
RMQMessaging_Transmit=on
RESERVATION=ncfs-dev

# Input files and templates

GRIDNAME=nc_inundation_v9.99_w_rivers
source $SCRIPTDIR/config/mesh_defaults.sh

# Physical forcing (defaults set in config/forcing_defaults.sh)

TIDEFAC=on               # tide factor recalc
   HINDCASTLENGTH=25.0   # length of initial hindcast, from cold (days)
BACKGROUNDMET=off         # NAM download/forcing
   FORECASTCYCLE="00,06,12,18"
TROPICALCYCLONE=on      # tropical cyclone forcing
   STORM=05              # storm number, e.g. 05=ernesto in 2006
   YEAR=2019             # year of the storm
WAVES=on                # wave forcing
   REINITIALIZESWAN=yes   # used to bounce the wave solution
VARFLUX=on               # variable river flux forcing
   RIVERSITE=data.disaster.renci.org
   RIVERDIR=/opt/ldm/storage/SCOOP/RHLRv9-OKU
   RIVERUSER=bblanton
   RIVERDATAPROTOCOL=scp
CYCLETIMELIMIT="99:00:00"

# Computational Resources (related defaults set in platforms.sh)

NCPU=511                     # number of compute CPUs for all simulations
NCPUCAPACITY=2048
NUMWRITERS=1
ACCOUNT=null

# Post processing and publication

INTENDEDAUDIENCE=general    # "general" | "developers-only" | "professional"
#POSTPROCESS=( accumulateMinMax.sh createMaxCSV.sh cpra_slide_deck_post.sh includeWind10m.sh createOPeNDAPFileList.sh opendap_post.sh )
POSTPROCESS=( includeWind10m.sh createOPeNDAPFileList.sh opendap_post.sh )
#OPENDAPNOTIFY="asgs.cera.lsu@gmail.com jason.g.fleming@gmail.com"
OPENDAPNOTIFY="bblanton@renci.org asgs.cera.lsu@gmail.com"
NOTIFY_SCRIPT=ncfs_cyclone_notify.sh

# Initial state (overridden by STATEFILE after ASGS gets going)

COLDSTARTDATE=auto  # calendar year month day hour YYYYMMDDHH24
HOTORCOLD=hotstart       # "hotstart" or "coldstart"
#LASTSUBDIR=null
LASTSUBDIR=/scratch/ncfs-dev/ncfs-dev-ncv99-nam-master/asgs28855/2019083112

# Scenario package

#PERCENT=default
SCENARIOPACKAGESIZE=3
case $si in
   -2) 
       ENSTORM=hindcast
       ;;
   -1)      
       # do nothing ... this is not a forecast
       ENSTORM=nowcast
       ;;
    0)
       ENSTORM=nhcOfcl
       ;;
    1)
       ENSTORM=veerLeft50
       PERCENT=-50
       ;;
    2)
       ENSTORM=veerLeft100
       PERCENT=-100
       ;;
    3)
       ENSTORM=veerRight100
       PERCENT=100
       ;;
    4)
       ENSTORM=veerRight50
       PERCENT=50
       ;;
    *)   
       echo "CONFIGRATION ERROR: Unknown ensemble member number: '$si'."
      ;;
esac

PREPPEDARCHIVE=prepped_${GRIDNAME}_${INSTANCENAME}_${NCPU}.tar.gz
HINDCASTARCHIVE=prepped_${GRIDNAME}_hc_${INSTANCENAME}_${NCPU}.tar.gz
