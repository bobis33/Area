<template>
  <div>
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
import { ref, onMounted } from 'vue'
const config = useRuntimeConfig()

const { data, error } = await useFetch(`${config.public.baseUrlApi}/area/get/all`, {
  method: 'GET',
  headers: {
    'Content-Type': 'application/json',
  },
})

const newArea = ref({
  action: '',
  reaction: ''
})

const userEmails = ref({})
const userEmail = ref('')
const subscribedAreas = ref([])

const createArea = async () => {
  try {
    const response = await fetch(`${config.public.baseUrlApi}/area/create?action=${newArea.value.action}&reaction=${newArea.value.reaction}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
    })
  } catch (error) {
    console.error('Error creating area:', error)
  }
}

const subscribeUser = async (area_id) => {
  const email = userEmails.value[area_id]
  if (!email) {
    alert('Please enter your email.')
    return
  }
  try {
    console.log(email)
    console.log(area_id)
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

</script>

<style scoped>
/* Add your styles here */
</style>