<template>
  <div>
      <button @click="router.push(RoutesEnum.HOME.toString())" class="btn-back-home">{{ $t('goBackHome') }}</button>
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
import { useRouter } from '#app'
import {CookiesEnum, RoutesEnum} from "~/config/constants";
import { useCookie } from "#app";

const token = useCookie(CookiesEnum.TOKEN.toString()).value
const config = useRuntimeConfig()
const router = useRouter()
const userEmails = ref({})
const userEmail = ref('')
const subscribedAreas = ref([])
const newArea = ref({
  action: '',
  reaction: ''
})

const { data, error } = await useFetch(`${config.public.baseUrlApi}/area/get/all`, {
  method: 'GET',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${token}`,
  },
})

const fetchSubscribedAreas = async () => {
  try {
    const response = await fetch(`${config.public.baseUrlApi}/area/get/subscribed`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
      },
    })
    const result = await response.json()
    subscribedAreas.value = result['subscribed_areas']
  } catch (error) {
    console.error('Error fetching subscribed areas:', error)
  }
}

const subscribeUser = async (area_id) => {
  try {
    const response = await fetch(`${config.public.baseUrlApi}/area/subscribe&area_id=${area_id}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
      },
    })
    const result = await response.json()
    await fetchSubscribedAreas()
  } catch (error) {
    console.error('Error subscribing user:', error)
  }
}

const unsubscribeUser = async (area_id) => {
  try {
    const response = await fetch(`${config.public.baseUrlApi}/area/unsubscribe&area_id=${area_id}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
      }
    })
    const result = await response.json()
    await fetchSubscribedAreas()
  } catch (error) {
    console.error('Error unsubscribing user:', error)
  }
}

const createArea = async () => {
  try {
    const url = `${config.public.baseUrlApi}/area/create?action=${(newArea.value.action)}&reaction=${(newArea.value.reaction)}`
    const response = await fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
      }
    })
    if (!response.ok) {
      throw new Error('Network response was not ok')
    }
    const result = await response.json()
    console.log(result.message)
    // Optionally, fetch the updated list of areas
    // fetchAreas()
  } catch (error) {
    console.error('Error creating area:', error)
  }
}
</script>

<style scoped lang="scss">
.btn-back-home {
  background-color: #4CAF50;
  color: white;
  border: none;
  padding: 10px 20px;
  cursor: pointer;
  border-radius: 5px;
  font-size: 14px;
  margin-top: 20px;
}
</style>
