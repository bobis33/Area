<template>
  <div>
    <h2>{{$t('subscribedArea')}}</h2>
    <div>
      <button @click="fetchSubscribedAreas">{{$t('fetchSubscribedAreas')}}</button>
    </div>
    <div v-if="subscribedAreas.length">
      <ul>
        <li v-for="area in subscribedAreas" :key="area._id" class="area-box">
          <strong>{{ $t('action') }}:</strong> {{ area.action }} <br>
          <strong>{{ $t('reaction') }}:</strong> {{ area.reaction }}
          <strong>{{ $t('params action') }}:</strong> <br>
          <ul>
            <li v-for="(value, key) in area.action_params" :key="key">
              <strong>{{ $t(key) }}:</strong> {{ value }}
            </li>
          </ul>
          <strong>{{ $t('params reaction') }}:</strong> <br>
          <ul>
            <li v-for="(value, key) in area.reaction_params" :key="key">
              <strong>{{ $t(key) }}:</strong> {{ value }}
            </li>
          </ul>
          <button @click="unsubscribeUser(area._id)">{{$t('Unsubscribe')}}</button>
        </li>
      </ul>
    </div>
    <div v-else>
      <p>No subscribed areas found.</p>
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
      const response = await new Areas().unsubscribeUser(area_id, token);
      await fetchSubscribedAreas()
    } else {
      console.error('Token is not available');
    }
  } catch (error) {
    console.error('Error unsubscribing user:', error)
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

onMounted(() => {
  fetchSubscribedAreas();
});

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
