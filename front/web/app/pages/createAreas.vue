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
                v-model="action.params[key]"
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
                v-model="reaction.params[key]"
              />
            </div>
          </li>
        </ul>
      </div>
      <div v-else>
        <p>No reactions found.</p>
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
    }
  };
  
  const selectReaction = (reaction: Reaction) => {
    if (selectedReaction.value === reaction) {
      selectedReaction.value = null;
    } else {
      selectedReaction.value = reaction;
    }
  };
  
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
    flex-direction: column;
    align-content: stretch;
  }
  
  .reactions-container {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
    flex-direction: column;
    align-content: stretch;
  }
  
  .areas-container {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
    flex-direction: column;
    align-content: stretch;
  }
  
  .flex-container {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(30%, 1fr)); /* Boxes are always 30% wide */
    gap: 10px;
    list-style-type: none;
    padding: 0;
  }
  
  .area-box {
    box-sizing: border-box; /* Includes padding and border in width calculation */
    width: 100%;           /* Enforce full width within grid cell */
    padding: 10px;
    border: 1px solid #ccc;
    text-align: left;
    min-height: 200px;      /* Optional: Enforce consistent height */
  }
  
  input[type="text"] {
    box-sizing: border-box;
    width: 100%;
    padding: 5px;
    margin-top: 5px;
    color: #000; /* Ensure text color is visible */
    background-color: #fff; /* Ensure background color contrasts with text color */
    border: 1px solid #ccc; /* Optional: Add border for better visibility */
  }
  
  .param-input {
    color: #000; /* Ensure text color is visible */
    background-color: #fff; /* Ensure background color contrasts with text color */
    padding: 5px;
    margin-top: 5px;
    width: 100%;
    border: 1px solid #ccc; /* Optional: Add border for better visibility */
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
  