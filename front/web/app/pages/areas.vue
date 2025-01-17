<template>
  <section class="hero is-fullheight" style="background-color: #272727;">
      <div class="container">
        <div class="columns is-vcentered" style="padding-top: 5%; padding-bottom: 2%; color: white;">
        <div class="column is-4"></div>
        <div class="column is-4 has-text-centered">
          <h1 class="title">{{ $t('Shared AREAS') }}</h1>
        </div>
        <div class="column is-4 has-text-right">
            <div style="display: flex; justify-content: flex-end; margin-right: 10%;">
              <div style="display: flex; align-items: center; margin-right: 20px;">
                <nuxt-link to="/subscribedAreas" class="link-button" style="color: white;">{{$t('My AREAS')}}</nuxt-link>
              </div>
              <div style="display: flex; align-items: center;">
                <nuxt-link to="/createAreas" class="link-button" style="color: white;">{{$t('Create')}}</nuxt-link>
              </div>
              <nuxt-link to="/profile" class="link-button" style="color: white;">
                <img src="@/assets/icons/account.png" alt="Plus Icon" style="width: 30; height: 30px; filter: invert(1); margin: 3px; padding-left: 20px;"/>
              </nuxt-link>
            </div>
        </div>
      </div>
        <div class="field">
          <div class="control">
            <div class="is-flex is-justify-content-center">
              <input class="input is-normal" type="text" placeholder="Search by name or service" v-model="searchQuery" style="max-width: 30%;background-color: #343434">
            </div>
          </div>
        </div>
        <div v-if="filteredAreas.length" class="areas-container" style="padding-top: 2%">
          <ul class="columns is-multiline">
            <li v-for="area in filteredAreas" :key="area._id" class="column is-one-quarter">
              <div class="card is-flex is-flex-direction-column is-justify-content-space-between" style="height: 100%; background-color: #000000; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.5);">
                <div class="has-text-centered" style="padding-bottom: 5%; padding-top: 5%;">
                  <strong>{{ area.action }}</strong> <br>
                  <strong>{{ area.reaction }}</strong>
                </div>
                <div class="card-footer" style="background-color: #343434; padding: 0.3rem 1rem;">
                  <img src="@/assets/icons/download.png" alt="Download Icon" style="width: 17px; height: 17px; filter: invert(1); margin: 3px;"/>
                  <p style="margin-left: 7px;">
                    {{ area.subscribed_users.length }}
                  </p>
                  <a style="margin-left: auto; color: white;" @click="subscribeUser(area._id)">
                    <img src="@/assets/icons/plus.png" alt="Plus Icon" style="width: 17px; height: 17px; filter: invert(1); margin: 3px;"/>
                  </a>
                </div>
              </div>
            </li>
          </ul>
        </div>
        <div v-else>
          <p class="notification is-warning">No areas found.</p>
        </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useCookie } from '#app'
import { CookiesEnum } from "~/config/constants";
import { Areas } from '~/infrastructure/repositories/AreaRepository'

const token = useCookie(CookiesEnum.TOKEN.toString()).value
const config = useRuntimeConfig()

interface Area {
  _id: string;
  action: string;
  action_params: {};
  reaction: string;
  reaction_params: {};
}

interface params {
  [key: string]: string;
}
const subscribedAreas = ref<Area[]>([])
const searchQuery = ref('')

interface Action {
  name: string;
  description: string;
  service: string;
  params: params;
}

interface Reaction {
  name: string;
  description: string;
  service: string;
  params: params;
}

const { data, error } = await useFetch<{ areas: Area[] }>(`${config.public.baseUrlApi}/area/get/all`, {
  method: 'GET',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${token}`,
  },
})

const fetchSubscribedAreas = async () => {
  try {
    if (token) {
      subscribedAreas.value = await new Areas().fetchSubscribedAreas(token)
    } else {
      console.error('Token is not available');
    }
  } catch (error) {
    console.error('Error fetching subscribed areas:', error)
  }
}

const subscribeUser = async (area_id: string) => {
  try {
    if (token) {
      console.log(area_id)
      const response = await new Areas().subscribeUser(area_id, token);
      await fetchSubscribedAreas()
    } else {
      console.error('Token is not available');
    }
  } catch (error) {
    console.error('Error subscribing user:', error)
  }
}

const getServiceClass = (service: string) => {
  switch (service) {
    case 'GMail':
      return 'gmail-box';
    case 'Github':
      return 'github-box';
    case 'Spotify':
      return 'spotify-box';
    default:
      return '';
  }
}

const filteredAreas = computed(() => {
  if (!data.value || !data.value.areas) return []
  return data.value.areas.filter(area => {
    const searchLower = searchQuery.value.toLowerCase()
    return area.action.toLowerCase().includes(searchLower) || area.reaction.toLowerCase().includes(searchLower)
  })
})
</script>

<style scoped lang="scss">
@import "https://cdn.jsdelivr.net/npm/bulma@1.0.2/css/bulma.min.css";
html, body {
  height: 100%;
}
</style>