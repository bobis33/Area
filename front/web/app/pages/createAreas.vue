<template>
  <div>
    <div class="area-container">
      <div v-if="actionsData && actionsData.actions.length" class="area-box action-box">
        <h1>{{ $t('Action') }}</h1>
        <select v-model="actionSelectedService" class="dropdown-menu">
          <option disabled selected value="" style="color: black;">{{ $t('Service') }}</option>
          <option v-for="service in services" :key="service" :value="service" style="color: black;">
            {{ service }}
          </option>
        </select>
        <select v-if="actionSelectedService && filteredActions" v-model="selectedAction" class="dropdown-menu">
          <option disabled selected value="" style="color: black;">{{ $t('Action') }}</option>
          <option v-for="action in filteredActions" :key="action.name" :value="action" style="color: black;">
            {{ action.name }}
        </option>
      </select>
      <div v-if="selectedAction && selectedAction.params">
        <div v-for="(value, key) in selectedAction.params" :key="key">
          <label :for="String(key)">{{ $t(String(key)) }}:</label>
          <input
          v-if="value || typeof value === 'string'"
          :id="String(key)"
          type="text"
          v-model="selectedAction.params[key]"
          />
        </div>
        <div v-if="selectedAction && selectedAction.description">
          <p>{{ selectedAction.description }}</p>
        </div>
      </div>
    </div>

    <div v-if="reactionsData && reactionsData.reactions.length" class="area-box reaction-box">
      <h1>{{ $t('Reaction') }}</h1>
      <select v-model="reactionSelectedService" class="dropdown-menu">
        <option disabled selected value="" style="color: black;">{{ $t('Service') }}</option>
        <option v-for="service in services" :key="service" :value="service" style="color: black;">
          {{ service }}
        </option>
      </select>
      <select v-if="reactionSelectedService && filteredReactions" v-model="selectedReaction" class="dropdown-menu">
        <option disabled selected value="" style="color: black;">{{ $t('Reaction') }}</option>
        <option v-for="reaction in filteredReactions" :key="reaction.name" :value="reaction" style="color: black;">
          {{ reaction.name }}
        </option>
      </select>
      <div v-if="selectedReaction && selectedReaction.params">
        <div v-for="(value, key) in selectedReaction.params" :key="key">
        <label :for="String(key)">{{ $t(String(key)) }}:</label>
        <input v-if="value || typeof value === 'string'":id="String(key)" type="text" v-model="selectedReaction.params[key]"/>
      </div>
      <div v-if="selectedReaction && selectedReaction.description">
        <p>{{ selectedReaction.description }}</p>
      </div>
      </div>
        <div v-else>
          <p>No reactions found.</p>
        </div>
      </div>
      <button @click="createArea" class="save-button">{{$t('save')}}</button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useCookie } from '#app'
import { CookiesEnum } from "~/config/constants";
import { Areas } from '~/infrastructure/repositories/AreaRepository'

const token = useCookie(CookiesEnum.TOKEN.toString()).value
const config = useRuntimeConfig()

enum services {
  Discord = 'Discord',
  GitHub = 'Github',
  GMail = 'GMail',
  Microsoft = 'Microsoft',
  Spotify = 'Spotify'
}

const actionSelectedService = ref<services | null>(null)
const reactionSelectedService = ref<services | null>(null)

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

const selectedAction = ref<Action | null>(null);
const selectedReaction = ref<Reaction | null>(null);

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

const filteredActions = computed(() => {
  return actionsData.value ? actionsData.value.actions.filter((action: Action) => action.service === actionSelectedService.value) : [];
});

const filteredReactions = computed(() => {
  return reactionsData.value ? reactionsData.value.reactions.filter((reaction: Reaction) => reaction.service === reactionSelectedService.value) : [];
});

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

.area-container {
  display: flex;
  gap: 10px;
  align-content: stretch;
  flex-wrap: nowrap;
  flex-direction: row;
}

.flex-container {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(30%, 1fr));
  gap: 10px;
  list-style-type: none;
  padding: 0;
}

.area-box {
  box-sizing: border-box;
  width: 100%;
  padding: 10px;
  border: 1px solid #ccc;
  text-align: left;
  min-height: 200px;
}

.dropdown-menu {
  box-sizing: border-box;
  width: 100%;
  padding: 5px;
  margin-top: 5px;
  color: #000;
  background-color: #fff;
  border: 1px solid #ccc;
}

  input[type="text"] {
    box-sizing: border-box;
    width: 100%;
    padding: 5px;
    margin-top: 5px;
    color: #000;
    background-color: #fff;
    border: 1px solid #ccc;
  }

  .param-input {
    color: #000;
    background-color: #fff;
    padding: 5px;
    margin-top: 5px;
    width: 100%;
    border: 1px solid #ccc;
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
    background-color: #007bff;
    color: white;
  }

  .reaction-box {
    background-color: #dc3545;
    color: white;
  }

.save-button {
  position: fixed;
  bottom: 20px;
  right: 20px;
  padding: 10px 20px;
  border: none;
  border-radius: 25px;
  background-color: #007BFF;
  color: white;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.save-button:hover {
  background-color: #0056b3;
}
</style>
