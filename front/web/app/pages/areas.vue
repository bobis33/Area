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
import { defineComponent, ref, onMounted } from 'vue'
import { Areas } from '~/areas/areas'
import type { AreasInterface } from '~/areas/areasInterface'
import { useRouter } from '#app'
import {CookiesEnum, RoutesEnum} from "~/config/constants";
import { useCookie } from "#app";

const token = useCookie(CookiesEnum.TOKEN.toString()).value
const config = useRuntimeConfig()
const router = useRouter()

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
      const response = await new Areas().fetchSubscribedAreas(token);
      subscribedAreas.value = response
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
