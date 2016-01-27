import RiotAPI
import csv

def main():
    api = RiotAPI.RiotAPI('ef03e285-aa1e-486d-864a-2d3f0fe2857e')
    r = api.get_champ('spells')['data']
    nd = []
    print(r['Jinx']['spells'])

main()