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
INSTANCENAME=LAv20a_nam_bde_10cm     # "name" of this ASGS process
ACCOUNT=ADCIRC
QOS=vip7000 # for priority during a storm
QUEUENAME=normal # same as SLURM partition
SERQUEUE=normal
PPN=24
GROUP="G-803086"
ASGSADMIN="asgsnotifications@opayq.com"

# Input files and templates

GRIDNAME=LAv20a
source $SCRIPTDIR/config/mesh_defaults.sh
NAFILE=LA_v20a-WithUpperAtch_chk_10cm.13
NAPROPERTIES=${NAFILE}.properties


# Physical forcing (defaults set in config/forcing_defaults.sh)
TIDEFAC=on               # tide factor recalc
   HINDCASTLENGTH=30.0   # length of initial hindcast, from cold (days)
BACKGROUNDMET=on         # NAM download/forcing
   FORECASTCYCLE="00,06,12,18"
TROPICALCYCLONE=off      # tropical cyclone forcing
   STORM=26              # storm number, e.g. 05=ernesto in 2006
   YEAR=2020             # year of the storm
WAVES=on                 # wave forcing
   REINITIALIZESWAN=no   # used to bounce the wave solution
VARFLUX=off              # variable river flux forcing
#STATICOFFSET=0.30
#
CYCLETIMELIMIT="99:00:00"

# Computational Resources (related defaults set in platforms.sh)

NCPU=959                    # number of compute CPUs for all simulations
NCPUCAPACITY=9999
NUMWRITERS=1

# Post processing and publication

INTENDEDAUDIENCE=general    # "general" | "developers-only" | "professional"
#POSTPROCESS=( accumulateMinMax.sh createMaxCSV.sh cpra_slide_deck_post.sh includeWind10m.sh createOPeNDAPFileList.sh opendap_post.sh )
POSTPROCESS=( includeWind10m.sh createOPeNDAPFileList.sh opendap_post.sh )
OPENDAPNOTIFY="asgs.cera.lsu@gmail.com,jason.g.fleming@gmail.com,clint@oden.utexas.edu,amin.kiaghadi2013@gmail.com,m.botto_t@utexas.edu,asgsnotifications@opayq.com,rluettich1@gmail.com,cera.asgs.tk@gmail.com,asgsnotes4ian@gmail.com,Patrick.C.Kerr@usace.army.mil"
NOTIFY_SCRIPT=ut-nam-notify.sh
TDS=( tacc_tds lsu_tds )

# Initial state (overridden by STATEFILE after ASGS gets going)

# bde20200919: must coldstart with new +10cm steric adjustment
COLDSTARTDATE=auto
HOTORCOLD=hotstart
LASTSUBDIR=https://fortytwo.cct.lsu.edu/thredds/fileServer/2020/nam/2020100418/LA_v20a-WithUpperAtch_chk/queenbeeC.loni.org/LAv20a_nam_jgf_10cm/nowcast
#
# Scenario package
#
#PERCENT=default
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
   ENSTORM=namforecastWind10m
   ;;
  1)
   ENSTORM=namforecast
   ;;
*)
   echo "CONFIGRATION ERROR: Unknown scenario number: '$si'."
   ;;
esac
source $SCRIPTDIR/config/io_defaults.sh # sets met-only mode based on "Wind10m" suffix
#
PREPPEDARCHIVE=prepped_${GRIDNAME}_${INSTANCENAME}_${NCPU}.tar.gz
HINDCASTARCHIVE=prepped_${GRIDNAME}_hc_${INSTANCENAME}_${NCPU}.tar.gz
