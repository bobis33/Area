<template>
  <div>
    <h1>{{ $t('allAction') }}</h1>
    <div v-if="actionsData && actionsData.actions.length" class="actions-container">
      <ul class="flex-container">
        <li v-for="action in actionsData.actions" :key="action.name" class="area-box action-box">
          <input
  type="checkbox"
  :checked="!!selectedAction && selectedAction.name === action.name"
  @change="selectAction(action)"/>  
          <strong>{{ $t('name') }}:</strong> {{ action.name }} <br />
          <strong>{{ $t('description') }}:</strong> {{ action.description }}
          <div v-for="(value, key) in action.params" :key="key">
            <label :for="String(key)">{{ $t(String(key)) }}:</label>
            <input
              v-if="value || typeof value === 'string'"
              :id="String(key)"
              type="text"
              v-model="newArea.action.params[key]"
            />
          </div>
        </li>
      </ul>
    </div>
    <div v-else>
      <p>No actions found.</p>
    </div>

    <h1>{{ $t('allReaction') }}</h1>
    <div v-if="reactionsData && reactionsData.reactions && reactionsData.reactions.length" class="reactions-container">
      <ul class="flex-container">
        <li v-for="reaction in reactionsData.reactions" :key="reaction.name" class="area-box reaction-box">
          <input type="checkbox" :checked="!!selectedReaction && selectedReaction.name === reaction.name"
           @change="selectReaction(reaction)">
          <strong>{{ $t('name') }}:</strong> {{ reaction.name }} <br>
          <strong>{{ $t('description') }}:</strong> {{ reaction.description }}
          <div v-for="(value, key) in reaction.params" :key="key">
            <label :for="String(key)">{{ $t(String(key)) }}:</label>
            <input
              v-if="value || typeof value === 'string'"
              :id="String(key)"
              type="text"
              v-model="newArea.reaction.params[key]"
            />
          </div>
        </li>
      </ul>
    </div>
    <div v-else>
      <p>No reactions found.</p>
    </div>

    <h1>{{ $t('allAreas') }}</h1>
    <div v-if="data && data.areas.length" class="areas-container">
      <ul class="flex-container">
        <li v-for="area in data.areas" :key="area._id" class="area-box">
          <strong>{{ $t('action') }}:</strong> {{ area.action }} <br>
          <strong>{{ $t('reaction') }}:</strong> {{ area.reaction }}
          <strong>{{ $t('params action') }}:</strong> {{ area.action_params }} <br>
          <strong>{{ $t('params reaction') }}:</strong> {{ area.reaction_params }}
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

    <button @click="createArea">{{$t('createArea')}}</button>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useCookie } from '#app'
import { CookiesEnum } from "~/config/constants";
import { Areas } from '~/infrastructure/repositories/AreaRepository'

const token = useCookie(CookiesEnum.TOKEN.toString()).value
const config = useRuntimeConfig()

interface Area {
  _id: string;
  action: Action;
  action_params: {},
  reaction: Reaction;
  reaction_params: {}
}

interface params {
  [key: string]: string;
}
const subscribedAreas = ref<Area[]>([])
const newArea = ref<Area>({
  _id: '',
  action: {
    name: '',
    description: '',
    service: '',
    params: {}
  },
  action_params: {},
  reaction: {
    name: '',
    description: '',
    service: '',
    params: {}
  },
  reaction_params: {}
})

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

const selectedAction = ref<Action | null>(null);
const selectedReaction = ref<Reaction | null>(null);

const selectAction = (action: Action) => {
  if (selectedAction.value === action) {
    selectedAction.value = null;
  } else {
    selectedAction.value = action;
    selectedAction.value.params = newArea.value.action.params;
  }
};

const selectReaction = (reaction: Reaction) => {
  if (selectedReaction.value === reaction) {
    selectedReaction.value = null;
  } else {
    selectedReaction.value = reaction;
    selectedReaction.value.params = newArea.value.reaction.params;
  }
};
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
      if (selectedAction.value && selectedReaction.value) {
        const response = await new Areas().createArea(selectedAction.value.name, selectedReaction.value.name, token, JSON.stringify(selectedAction.value.params), JSON.stringify(selectedReaction.value.params));
      }
    } else {
      console.error('Token is not available');
    }
  } catch (error) {
    console.error('Error creating area:', error)
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
</script>

<style scoped lang="scss">
.actions-container {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.reactions-container {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.areas-container {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.flex-container {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  list-style-type: none;
  padding: 0;
}

.area-box {
  border: 1px solid #ccc;
  padding: 10px;
  margin: 5px;
  width: 200px;
  box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.1);
  background-color: #f9f9f9;
}

.gmail-box {
  background-color: #B02D2D;
  color: white;
}

.github-box {
  background-color: #3C2A3D;
  color: white;
}

.spotify-box {
  background-color: #1db954;
  color: white;
}

  strong {
    display: block;
    margin-bottom: 8px;
  }

.action-box {
  background-color: #007bff; /* Blue */
  color: white;
}

.reaction-box {
  background-color: #dc3545; /* Red */
  color: white;
}
</style>
