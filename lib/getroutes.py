#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Dec  2 23:31:03 2017

@author: KathrynL
"""

import googlemaps
#from datetime import datetime
import pandas as pd

gmaps = googlemaps.Client(key='AIzaSyDb9ienJ3x85FXGecmLWql_uGSm4Q9unjo')

routes=pd.read_csv("~/Desktop/route_update.csv")
station_info=pd.read_csv("~/Desktop/station_info.csv")
station_info.index=station_info['id']

#now = datetime.now()

for j in range(64155,len(routes)):
    print(j)
    route_id=routes['route.id'][j]
    start=station_info.loc[routes['start'][j]]
    end=station_info.loc[routes['end'][j]]
    directions_result = gmaps.directions({'lng':start['lng'] , 'lat':start['lat']},
                                         {'lng':end['lng'] , 'lat':end['lat']},
                                         mode="bicycling")
    if(len(directions_result)==0):
        print("noo")
    if(len(directions_result)>0):
        directions_result=directions_result[0]
        x=directions_result['legs'][0]
        start=x['start_location']
        end=x['end_location']
        step=x['steps']
        z=[[start['lat'],start['lng']]]
        for i in range(len(step)):
            y=step[i]
            y=y['start_location']
            z.append([y['lat'],y['lng']])
        y=step[i]
        y=y['end_location']
        z.append([y['lat'],y['lng']])
        z.append([end['lat'],end['lng']])
        df=pd.DataFrame(z)
        df.columns=('lat','lon')
        df['time']=x['duration']['text']
        df['start']=routes['start'][j]
        df['end']=routes['end'][j]
        df.to_csv("~/Desktop/routes/"+route_id+".csv")

