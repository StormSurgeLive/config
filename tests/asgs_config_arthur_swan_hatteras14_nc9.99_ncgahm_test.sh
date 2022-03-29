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
# Copyright(C) 2006--2014 Jason Fleming
# Copyright(C) 2006, 2007 Brett Estrade 
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
#
# Fundamental 
#
INSTANCENAME=ncgahm         # name of this ASGS process
COLDSTARTDATE=2014042900
HOTORCOLD=hotstart          # "hotstart" or "coldstart" 
LASTSUBDIR=/projects/ncfs/data/asgs31792/2014070112
HINDCASTLENGTH=30.0         # length of initial hindcast, from cold (days)
REINITIALIZESWAN=no         # used to bounce the wave solution

# Source file paths

ADCIRCDIR=~/adcirc/GAHM_jie/work # ADCIRC executables 
SCRIPTDIR=~/asgs/trunk  # ASGS scripts/executables  
INPUTDIR=${SCRIPTDIR}/input/meshes/NCv9.98_012014   # dir containing grid and other input files 
OUTPUTDIR=${SCRIPTDIR}/output # dir containing post processing scripts

# Physical forcing

BACKGROUNDMET=off   # [de]activate NAM download/forcing 
TIDEFAC=on          # [de]activate tide factor recalc 
TROPICALCYCLONE=on  # [de]activate tropical cyclone forcing (temp. broken)
WAVES=on            # [de]activate wave forcing 
VARFLUX=off         # [de]activate variable river flux forcing
VORTEXMODEL=GAHM    # specify which vortex model to use when TROPICALCYCLONE=on

# Computational Resources

TIMESTEPSIZE=0.5
SWANDT=1200
HINDCASTWALLTIME="24:00:00"
ADCPREPWALLTIME="00:15:00"
NOWCASTWALLTIME="10:00:00"  # must have leading zero, e.g., 05:00:00
FORECASTWALLTIME="05:00:00" # must have leading zero, e.g., 05:00:00
NCPU=480
NCPUCAPACITY=480
CYCLETIMELIMIT="05:00:00"
# queue
QUEUENAME=null
SERQUEUE=null
SCRATCHDIR=/projects/ncfs/data # for the NCFS on blueridge
ACCOUNT=batch # or "ncfs" on hatteras to use pre-empt capability

# External data sources : Tropical cyclones

STORM=01  # storm number, e.g. 05=ernesto in 2006 
YEAR=2014 # year of the storm (useful for historical storms) 
TRIGGER=rssembedded    # either "ftp" or "rss"
#RSSSITE=www.nhc.noaa.gov
RSSSITE=filesystem 
#FTPSITE=ftp.nhc.noaa.gov  # real anon ftp site for hindcast/forecast files
FTPSITE=filesystem
#FDIR=/atcf/afst     # forecast dir on nhc ftp site 
FDIR=/home/ncfs/asgs/trunk/input/sample_advisories
#HDIR=/atcf/btk      # hindcast dir on nhc ftp site 
HDIR=/home/ncfs/asgs/trunk/input/sample_advisories

# External data sources : Background Meteorology

FORECASTCYCLE="00,12"
BACKSITE=ftp.ncep.noaa.gov          # NAM forecast data from NCEP
BACKDIR=/pub/data/nccf/com/nam/prod # contains the nam.yyyymmdd files
FORECASTLENGTH=84                   # hours of NAM forecast to run (max 84)
PTFILE=ptFile_oneEighth.txt         # the lat/lons for the OWI background met
ALTNAMDIR="/projects/ncfs/data/asgs16441"

# External data sources : River Flux

#RIVERSITE=ftp.nssl.noaa.gov
#RIVERDIR=/projects/ciflow/adcirc_info

RIVERSITE=data.disaster.renci.org
RIVERDIR=/opt/ldm/storage/SCOOP/RHLRv9-OKU
RIVERUSER=ldm
RIVERDATAPROTOCOL=scp

# Input files and templates

GRIDFILE=nc_inundation_v9.99.grd
GRIDNAME=nc_inundation_v9.99
CONTROLTEMPLATE=nc_v9.99_corrarea.vortex.template
ELEVSTATIONS=nc_v9.98_elev_stations.txt
VELSTATIONS=null
METSTATIONS=nc_v9.98_met_stations.txt
NAFILE=nc_inundation_v9.99_MSL_evm_water_10_land_2_slope0.05.13
SWANTEMPLATE=fort.26.limiter.mxitns10.template
RIVERINIT=v6brivers.88
RIVERFLUX=v6brivers_fort.20_default
HINDCASTRIVERFLUX=v6brivers_fort.20_hc_default
PREPPEDARCHIVE=prepped_${GRIDNAME}_${INSTANCENAME}_${NCPU}.tar.gz
HINDCASTARCHIVE=prepped_${GRIDNAME}_hc_${INSTANCENAME}_${NCPU}.tar.gz

# Output files

# water surface elevation station output
FORT61="--fort61freq 900.0 --fort61netcdf"
# water current velocity station output
FORT62="--fort62freq 0"
# full domain water surface elevation output
FORT63="--fort63freq 3600.0 --fort63netcdf"
# full domain water current velocity output
FORT64="--fort64freq 0"
# met station output
FORT7172="--fort7172freq 3600.0 --fort7172netcdf"
# full domain meteorological output
FORT7374="--fort7374freq 3600.0 --fort7374netcdf"
#SPARSE="--sparse-output"
SPARSE=""
NETCDF4="--netcdf4"
OUTPUTOPTIONS="${SPARSE} ${NETCDF4} ${FORT61} ${FORT62} ${FORT63} ${FORT64} ${FORT7172} ${FORT7374}"
# fulldomain or subdomain hotstart files
HOTSTARTCOMP=fulldomain
# binary or netcdf hotstart files
HOTSTARTFORMAT=netcdf
# "continuous" or "reset" for maxele.63 etc files
MINMAX=reset

# Notification

EMAILNOTIFY=yes # set to yes to have host platform email notifications
NOTIFY_SCRIPT=ncfs_cyclone_notify.sh
ACTIVATE_LIST="jason.fleming@seahorsecoastal.com jason.g.fleming@gmail.com"
NEW_ADVISORY_LIST="jason.fleming@seahorsecoastal.com jason.g.fleming@gmail.com"
POST_INIT_LIST="jason.fleming@seahorsecoastal.com jason.g.fleming@gmail.com"
POST_LIST="jason.fleming@seahorsecoastal.com jason.g.fleming@gmail.com"
JOB_FAILED_LIST="jason.fleming@seahorsecoastal.com jason.g.fleming@gmail.com"
NOTIFYUSER=jason.fleming@seahorsecoastal.com
ASGSADMIN=jason.fleming@seahorsecoastal.com

# Post processing and publication

INTENDEDAUDIENCE=developers-only
INITPOST=null_init_post.sh
POSTPROCESS=ncfs_post.sh
TARGET=hatteras
POSTPROCESS2=null_post.sh
WEBHOST=alpha.he.net
WEBUSER=seahrse
WEBPATH=/home/seahrse/public_html/ASGS
OPENDAPHOST=br0.renci.org
OPENDAPUSER=ncfs
OPENDAPBASEDIR=/projects/ncfs/opendap/data
NUMCERASERVERS=2

# Archiving

ARCHIVE=ncfs_archive.sh
ARCHIVEBASE=/projects/ncfs/data
ARCHIVEDIR=archive

# Forecast ensemble members

RMAX=default
PERCENT=default
ENSEMBLESIZE=1 # number of storms in the ensemble
case $si in
-1)
      # do nothing ... this is not a forecast
   ;;
0)
   ENSTORM=nhcConsensus
   ;;
1)
   ENSTORM=veerLeft
   PERCENT=-100
   ;;
2)
   ENSTORM=veerLeft
   PERCENT=-30
   ;;
*)
   echo "CONFIGRATION ERROR: Unknown ensemble member number: '$si'."
   ;;
esac
