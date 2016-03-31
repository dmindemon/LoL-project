import RiotAPI
import csv

def main():
    api = RiotAPI.RiotAPI('ef03e285-aa1e-486d-864a-2d3f0fe2857e')
    r = api.get_champions()['champions']
    
    data = open('/Users/shenguangmin/Desktop/LoL-project/LoL API analysis/data/champions.csv', 'w')
    csvwriter = csv.writer(data)
    count = 0
    for row in r:
        if count == 0:
            header = row.keys()
            csvwriter.writerow(list(header))
            count +=1
        csvwriter.writerow(list(row.values()))
    data.close()

def main2():
    api = RiotAPI.RiotAPI('ef03e285-aa1e-486d-864a-2d3f0fe2857e')
    r = api.get_name()['data']
    nr = []
    for key in r:
        nr.append(r[key])
    print(nr)
    
    data = open('/Users/shenguangmin/Desktop/LoL-project/LoL API analysis/data/champDict.csv', 'w')
    csvwriter = csv.writer(data)
    count = 0
        
    for row in nr:
        if count == 0:
            header = row.keys()
            csvwriter.writerow(list(header))
            count +=1
        csvwriter.writerow(list(row.values()))
    data.close()
    

    

