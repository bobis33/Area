<template>
  <div>
    <h1>{{ $t('allActions') }}</h1>
    <div v-if="actionsData && actionsData.actions && actionsData.actions.length">
      <ul>
        <li v-for="action in actionsData.actions" class="area-box">
          <strong>{{ $t('name') }}:</strong> {{ action.name }} <br>
          <strong>{{ $t('description') }}:</strong> {{ action.description }}
        </li>
      </ul>
    </div>
    <div v-else>
      <p>No areas found.</p>
    </div>

    <h1>{{ $t('allReaction') }}</h1>
    <div v-if="reactionsData && reactionsData.reactions && reactionsData.reactions.length">
      <ul>
        <li v-for="reaction in reactionsData.reactions" class="area-box">
          <strong>{{ $t('name') }}:</strong> {{ reaction.name }} <br>
          <strong>{{ $t('description') }}:</strong> {{ reaction.description }}
        </li>
      </ul>
    </div>
    <div v-else>
      <p>No areas found.</p>
    </div>

    <h1>{{ $t('allAreas') }}</h1>
    <div v-if="data && data.areas.length">
      <ul>
        <li v-for="area in data.areas" :key="area._id" class="area-box">
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
        <li v-for="area in subscribedAreas" :key="area._id" class="area-box">
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

interface Action {
  name: string;
  description: string;
  service: string;
}

interface Reaction {
  name: string;
  description: string;
  service: string;
}

const { data, error } = await useFetch<{ areas: Area[] }>(`${config.public.baseUrlApi}/area/get/all`, {
  method: 'GET',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${token}`,
  },
})

const { data: actionsData, error: actionsError } = await useFetch<{ actions: Action[] }>(`${config.public.baseUrlApi}/area/get/actions`, {
  method: 'GET',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${token}`,
  },
})

const { data: reactionsData, error: reactionsError } = await useFetch<{ reactions: Reaction[] }>(`${config.public.baseUrlApi}/area/get/reactions`, {
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
.area-box {
  border: 1px solid #ccc;
  padding: 16px;
  margin-bottom: 16px;
  border-radius: 8px;
  background-color: #f9f9f9;

  strong {
    display: block;
    margin-bottom: 8px;
  }

}
</style>
