from RiotAPI import RiotAPI
import json
import csv

def main():
    api = RiotAPI('ef03e285-aa1e-486d-864a-2d3f0fe2857e')
    r = api.get_champions()['champions']
    
    data = open('/Users/shenguangmin/Desktop/LOL/data/champions.csv', 'w')
    csvwriter = csv.writer(data)
    count = 0
    for row in r:
        if count == 0:
            header = row.keys()
            csvwriter.writerow(list(header))
            count +=1
        csvwriter.writerow(list(row.values()))
    data.close()

    

if __name__ == "__main__":
    main()
    

