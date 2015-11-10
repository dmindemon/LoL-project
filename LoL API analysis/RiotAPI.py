import RiotConsts as Consts
import requests

class RiotAPI(object):
    def __init__(self, api_key):
        self.api_key = api_key

    def _request(self, api_url):
        key = {'api_key' : self.api_key}
        response = requests.get(
            Consts.URL['base'].format(url=api_url), key)
        print (response.url)
        return response.json()
    
    def get_champions(self):
        api_url = Consts.URL['content'].format(
            version = Consts.API_VERSIONS['champion_get'],)
        return self._request(api_url)
