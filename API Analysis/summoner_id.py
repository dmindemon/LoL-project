import RiotAPI
import time

def main():
    n = 1
    r = []
    key = 'ef03e285-aa1e-486d-864a-2d3f0fe2857e'
    test = RiotAPI.RiotAPI(key)
    while (n<20):
        print(test.summ_request(n)[str(n)])
        time.sleep(1)
        n = n + 1

main()



