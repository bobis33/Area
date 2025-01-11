<template>
  <div>
    <h1>{{ $t('allAreas') }}</h1>
    <div v-if="data && data.areas.length">
      <ul>
        <li v-for="area in data.areas" :key="area._id">
          <strong>{{ $t('action') }}:</strong> {{ area.action }} <br>
          <strong>{{ $t('reaction') }}:</strong> {{ area.reaction }}
          <button @click="subscribeUser(area._id)">{{ $t('Subscribe') }}</button>
        </li>
      </ul>
    </div>
    <div v-else>
      <p>No areas found.</p>
    </div>

    <h2>{{$t('subscribedArea')}}</h2>
    <div>
      <button @click="fetchSubscribedAreas">{{$t('fetchSubscribedAreas')}}</button>
    </div>
    <div v-if="subscribedAreas.length">
      <ul>
        <li v-for="area in subscribedAreas" :key="area._id">
          <strong>{{ $t('action') }}:</strong> {{ area.action }} <br>
          <strong>{{ $t('reaction') }}:</strong> {{ area.reaction }}
          <button @click="unsubscribeUser(area._id)">{{$t('Unsubscribe')}}</button>
        </li>
      </ul>
    </div>
    <div v-else>
      <p>No subscribed areas found.</p>
    </div>

    <h2>{{$t('createArea')}}</h2>
    <form @submit.prevent="createArea">
      <div>
        <label for="action">{{ $t('action') }}:</label>
        <input type="text" v-model="newArea.action" required />
      </div>
      <div>
        <label for="reaction">{{ $t('reaction') }}:</label>
        <input type="text" v-model="newArea.reaction" required />
      </div>
      <button type="submit">{{$t('createArea')}}</button>
    </form>

  </div>
</template>

<script setup lang="ts">
import {ref} from 'vue'
import {useCookie} from '#app'

import {CookiesEnum} from "~/config/constants";
import {Areas} from '~/infrastructure/repositories/AreaRepository'

const token = useCookie(CookiesEnum.TOKEN.toString()).value
const config = useRuntimeConfig()

interface Area {
  _id: string;
  action: string;
  reaction: string;
}

const subscribedAreas = ref<Area[]>([])
const newArea = ref({
  action: '',
  reaction: ''
})

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

const unsubscribeUser = async (area_id: string) => {
  try {
    if (token) {
      const response = await new Areas().unsubscribeUser(area_id, token);
      await fetchSubscribedAreas()
    } else {
      console.error('Token is not available');
    }
  } catch (error) {
    console.error('Error unsubscribing user:', error)
  }
}

const createArea = async () => {
  try {
    if (token) {
      const response = await new Areas().createArea(token, newArea.value.action, newArea.value.reaction);
    } else {
      console.error('Token is not available');
    }
  } catch (error) {
    console.error('Error creating area:', error)
  }
}
</script>

<style scoped lang="scss">
</style>
