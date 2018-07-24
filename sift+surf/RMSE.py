# -*- coding: utf-8 -*-
# @Author: sandeep
# @Date:   2018-07-19 20:22:01
# @Last Modified by:   chakri
# @Last Modified time: 2018-07-20 15:37:05


def readFile(filePath):
    ret = {}
    with open(filePath) as f:
        for line in f:
            lat,lon,x,y,_ = line.split()
            lat = float(lat)
            lon = float(lon)
            x = float(x)
            y = float(y)
            ret[(x,y)] = (lat,lon)
    return ret

def readFile1(filePath):
    ret = {}
    with open(filePath) as f:
        for line in f:
            x,y = line.split()
            x = round(x,0)
            y = round(y,0)
            ret[x]=y;
    return ret

def calcRMSE(data1,data2,data3):
    sigx = 0.0
    sigy = 0.0
    count = 0.0
    for point in data3.keys():
        (x,y) = (point,data3[point])
        lat1,lon1 = data1[(x,y)]
        lat2,lon2 = data2[(x,y)]
        sigx += (lat2-lat1) * (lat2 - lat1)
        sigy += (lon2 - lon1) * (lon2 - lon1)
        count +=1
    meanx = sigx/count
    meany = sigy/count
    rmsex = pow(meanx,0.5)
    rmsey = pow(meany,0.5)
    return rmsex,rmsey

def calcError(rmsex,rmsey):
    return pow(rmsex**2 +rmsey**2,0.5)

if __name__ == '__main__':
    # The code is not tested
    data1 = readFile("lat_long.txt") #SET THE FILE PATH
    data2 = readFile("lat_long_final.txt") #SET THE FILE PATH
    #data3 = readFile1("landsat_sift_surf.txt")
    #rmsex,rmsey = calcRMSE(data1,data2,data3)
    #error = calcError(rmsex,rmsey)
    #print (error)
