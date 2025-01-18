<template>
  <section :data-theme="$colorMode.preference" class="hero is-fullheight" :style="{ backgroundColor: 'var(--bg)' }">
    <div class="container">
      <div class="columns is-vcentered" style="padding-top: 5%; padding-bottom: 2%; color: white;">
        <div class="column is-4"></div>
        <div class="column is-4 has-text-centered">
          <h1 class="title" :style="{color: 'var(--text-color)'}">{{ $t('My_areas') }}</h1>
        </div>
        <div class="column is-4 has-text-right">
          <div style="display: flex; justify-content: flex-end; margin-right: 10%;">
            <div style="display: flex; align-items: center; justify-content: space-between; width: 100%;">
              <nuxt-link to="/subscribedAreas" class="link-button" :style="{color: 'var(--text-color)'}">{{$t('My_areas')}}</nuxt-link>
              <nuxt-link to="/createAreas" class="link-button" :style="{color: 'var(--text-color)'}">{{$t('Create')}}</nuxt-link>
              <nuxt-link to="/areas" class="link-button" :style="{color: 'var(--text-color)'}">{{$t('sharedAreas')}}</nuxt-link>
              <nuxt-link to="/profile" class="link-button" :style="{color: 'var(--text-color)'}">
                <img src="@/assets/icons/account.png" alt="Plus Icon" style="width: 30px; height: 30px;" :style="{filter: 'var(--filter)'}"/>
              </nuxt-link>
            </div>
          </div>
        </div>
      </div>
      <div v-if="filteredAreas.length" class="areas-container" style="padding-top: 2%">
        <ul class="columns is-multiline">
          <li v-for="area in filteredAreas" :key="area._id" class="column is-one-quarter">
            <div class="card is-flex is-flex-direction-column is-justify-content-space-between" :style="{ height: '100%', backgroundColor: 'black', boxShadow: '0 4px 8px rgba(0, 0, 0, 0.5)' }">
              <div class="has-text-centered" style="padding-bottom: 5%; padding-top: 5%;">
                <strong :style="{color: 'white'}">{{ area.action }}</strong> <br>
                <strong :style="{color: 'white'}">{{ area.reaction }}</strong>
              </div>
            </div>
          </li>
        </ul>
      </div>
      <div v-else>
        <p class="notification is-warning">No subscribed areas found.</p>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useCookie } from '#app'
import { CookiesEnum } from "~/config/constants";
import { Areas } from '~/infrastructure/repositories/AreaRepository'

const token = useCookie(CookiesEnum.TOKEN.toString()).value
const config = useRuntimeConfig()
interface params {
  [key: string]: string;
}

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

interface Area {
  _id: string;
  action: Action;
  action_params: {};
  reaction_params: {};
  reaction: Reaction;
  subscribed_users: string[];
}

const subscribedAreas = ref<Area[]>([])
const searchQuery = ref('')

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

const unsubscribeUser = async (area_id: string) => {
  try {
    if (token) {
      await new Areas().unsubscribeUser(area_id, token);
      await fetchSubscribedAreas()
    } else {
      console.error('Token is not available');
    }
  } catch (error) {
    console.error('Error unsubscribing user:', error)
  }
}

const filteredAreas = computed(() => {
  return subscribedAreas.value.filter(area =>
    area.action.name.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
    area.reaction.name.toLowerCase().includes(searchQuery.value.toLowerCase())
  )
})

onMounted(() => {
  fetchSubscribedAreas();
});
</script>

<style scoped>
@import "https://cdn.jsdelivr.net/npm/bulma@1.0.2/css/bulma.min.css";
html, body {
  height: 100%;
}
</style>