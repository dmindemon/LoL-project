import RiotConsts as Consts
import requests

class RiotAPI(object):
    # Set API key to the url
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
            version = Consts.API_VERSIONS['champion_get'])
        return self._request(api_url)

    def name_request(self, api_url):
        key = {'dataByld':'TRUE', 'api_key' : self.api_key}
        response = requests.get(
            Consts.URL['base_global'].format(url=api_url), key)
        print (response.url)
        return response.json()
    
    def get_name(self):
        api_url = Consts.URL['content'].format(
            version = Consts.API_VERSIONS['champion_get'])
        return self.name_request(api_url)

    def item_request(self, api_url, type=None):
        if type is None:
            key = {'api_key' : self.api_key}
        else:
            key = {'itemListData':type, 'api_key' : self.api_key}
        response = requests.get(
            Consts.URL['base_global'].format(url=api_url), key)
        print (response.url)
        return response.json()

    def get_item(self, type):
        api_url = Consts.URL['content'].format(
            version = Consts.API_VERSIONS['item'])
        return self.item_request(api_url, type)

    def champ_request(self, api_url, type=None):
        if type is None:
            key = {'api_key' : self.api_key}
        else:
            key = {'champData':type, 'api_key' : self.api_key}
        response = requests.get(
            Consts.URL['base_global'].format(url=api_url), key)
        print (response.url)
        return response.json()

    def get_champ(self, type):
        api_url = Consts.URL['content'].format(
            version = Consts.API_VERSIONS['champion_get'])
        return self.champ_request(api_url, type)

    def summ_request(self, id):
        # Making KEY for request
        key = {'api_key' : self.api_key}
        # Making URL for request
        url_suff = Consts.URL['content'].format(
            version = Consts.API_VERSIONS['summoner'])+str(id)
        url = Consts.URL['base'].format(url=url_suff)
        # Now we can request
        response = requests.get(url, key)
        print(response.url)
        return response.json()

