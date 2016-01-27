import RiotAPI
import csv

def main():
    api = RiotAPI.RiotAPI('ef03e285-aa1e-486d-864a-2d3f0fe2857e')
    r = api.get_item('gold')['data']
    sr = api.get_item('stats')['data']
    g = api.get_item('groups')['data']
    print(g['1413']['group'])

    nd = []
    n = 0
    for key in r:
        nd.append(r[key]['gold'])
        nd[n]['id']=r[key]['id']
        nd[n]['name']=r[key]['name']
        n = n+1

    n = 0
    for key in sr:
        nd[n].update({'stats':sr[key]['description']})
        n = n+1

    n = 0
    for key in g:
        if 'group' not in g[key]:
            nd[n].update({'group': 'NA'})
        else:
            nd[n].update({'group': g[key]['group']})
        n = n+1

    data = open('/Users/shenguangmin/Desktop/LoL-project/LoL API analysis/data/test.csv', 'w')
    csvwriter = csv.writer(data)
    count = 0
    for row in nd:
        if count == 0:
            header = row.keys()
            csvwriter.writerow(list(header))
            count +=1
        csvwriter.writerow(list(row.values()))
    data.close()

main()