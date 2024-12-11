<template>
  <div>
      <button @click="router.push(RoutesEnum.HOME.toString())" class="btn-back-home">Go to Home</button>
    <h1>All Areas</h1>
    <div v-if="data && data.areas.length">
      <ul>
        <li v-for="area in data.areas" :key="area._id">
          <strong>Action:</strong> {{ area.action }} <br>
          <strong>Reaction:</strong> {{ area.reaction }}
          <input type="email" v-model="userEmails[area._id]" placeholder="Enter your email" required />
          <button @click="subscribeUser(area._id)">Subscribe</button>
        </li>
      </ul>
    </div>
    <div v-else>
      <p>No areas found.</p>
    </div>

    <h2>Subscribed Areas</h2>
    <div>
      <input type="email" v-model="userEmail" placeholder="Enter your email to see subscribed areas" required />
      <button @click="fetchSubscribedAreas">Fetch Subscribed Areas</button>
    </div>
    <div v-if="subscribedAreas.length">
      <ul>
        <li v-for="area in subscribedAreas" :key="area._id">
          <strong>Action:</strong> {{ area.action }} <br>
          <strong>Reaction:</strong> {{ area.reaction }}
          <button @click="unsubscribeUser(area._id)">Unsubscribe</button>
        </li>
      </ul>
    </div>
    <div v-else>
      <p>No subscribed areas found.</p>
    </div>

    <h2>Create New Area</h2>
    <form @submit.prevent="createArea">
      <div>
        <label for="action">Action:</label>
        <input type="text" v-model="newArea.action" required />
      </div>
      <div>
        <label for="reaction">Reaction:</label>
        <input type="text" v-model="newArea.reaction" required />
      </div>
      <button type="submit">Create Area</button>
    </form>

  </div>
</template>

<script setup>
definePageMeta({middleware: 'auth'})
import { useRouter } from "#app";

import { RoutesEnum } from "~/constants";

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
  },
})

const fetchSubscribedAreas = async () => {
  if (!userEmail.value) {
    alert('Please enter your email.')
    return
  }
  try {
    const response = await fetch(`${config.public.baseUrlApi}/area/get/subscribed?user_email=${(userEmail.value)}`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      },
    })
    const result = await response.json()
    subscribedAreas.value = result.subscribed_areas
    console.log(subscribedAreas.value)
  } catch (error) {
    console.error('Error fetching subscribed areas:', error)
  }
}

const subscribeUser = async (area_id) => {
  const email = userEmails.value[area_id]
  if (!email) {
    alert('Please enter your email.')
    return
  }
  try {
    const response = await fetch(`${config.public.baseUrlApi}/area/subscribe?user_email=${(email)}&area_id=${area_id}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
    })
    const result = await response.json()
    console.log(result.message)
    fetchSubscribedAreas()
  } catch (error) {
    console.error('Error subscribing user:', error)
  }
}

const unsubscribeUser = async (area_id) => {
  if (!userEmail.value) {
    alert('Please enter your email.')
    return
  }
  try {
    const response = await fetch(`${config.public.baseUrlApi}/area/unsubscribe?user_email=${(userEmail.value)}&area_id=${area_id}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      }
    })
    const result = await response.json()
    console.log(result.message)
    fetchSubscribedAreas()
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

<style scoped>
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