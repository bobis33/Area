<template>
  <section :data-theme="$colorMode.preference" class="hero is-fullheight" :style="{ backgroundColor: 'var(--bg)' }">
    <div class="container">
      <div class="columns is-vcentered" style="padding-top: 5%; padding-bottom: 2%; color: var(--text);">
        <div class="column is-4">
          <nuxt-link to="/settings" class="link-button" :style="{color: 'var(--text-color)'}">
            <img src="@/assets/icons/settings.png" :alt="$t('settings')" style="width: 30px; height: 30px; margin: 3px;" :style="{filter: 'var(--filter)'}"/>
          </nuxt-link>
        </div>
        <div class="column is-4 has-text-centered">
          <h1 class="title">{{ $t('myAccount') }}</h1>
        </div>
        <div class="column is-4 has-text-right">
          <div style="display: flex; justify-content: flex-end; margin-right: 10%;">
            <div style="display: flex; align-items: center; justify-content: space-between; width: 100%;">
              <nuxt-link to="/subscribedAreas" class="link-button" :style="{color: 'var(--text-color)'}">{{$t('My AREAS')}}</nuxt-link>
              <nuxt-link to="/createAreas" class="link-button"  :style="{color: 'var(--text-color)'}">{{$t('Create')}}</nuxt-link>
              <nuxt-link to="/areas" class="link-button"  :style="{color: 'var(--text-color)'}">{{$t('Shared AREAS')}}</nuxt-link>
            </div>
          </div>
        </div>
      </div>

      <div class="columns is-centered">
        <div class="column is-half">
          <form @submit.prevent="changeUsername" class="box" :style="{ backgroundColor: 'var(--bg-secondary)', color: 'var(--text)', boxShadow: '#00000077 0px 4px 8px' }">
            <h2 class="title is-4">{{ $t('changeUsername') }}</h2>
            <div class="field">
              <label class="label" for="username">{{ $t('username') }}</label>
              <div class="control">
                <input id="username" class="input" type="text" v-model="username" placeholder="username" required>
              </div>
            </div>
            <div class="field">
              <div class="control">
                <button class="button is-link" type="submit" :aria-label="$t('changeUsername')">{{ $t('update') }}</button>
              </div>
            </div>
          </form>

          <form @submit.prevent="changePassword" class="box" :style="{ backgroundColor: 'var(--bg-secondary)', color: 'var(--text)', boxShadow: '#00000077 0px 4px 8px' }">
            <h2 class="title is-4">{{ $t('changePassword') }}</h2>
            <div class="field">
              <label class="label" for="password">{{ $t('password') }}</label>
              <div class="control">
                <input id="password" class="input" type="password" v-model="password" placeholder="password" required>
              </div>
            </div>
            <div class="field">
              <div class="control">
                <button class="button is-link" type="submit" :aria-label="$t('changePassword')">{{ $t('update') }}</button>
              </div>
            </div>
          </form>

          <div class="buttons is-centered">
            <button @click="logout" class="button is-danger" :aria-label="$t('logout')">{{ $t('logout') }}</button>
          </div>

          <div class="buttons is-centered">
            <button v-if="!isLinkedGoogle" @click="linkGoogleAccount" class="button is-link">
              <ImageComponent fileName="google.png" altText="Google logo" class="google-logo" />
              {{ $t('linkGoogleAccount') }}
            </button>
            <button v-else class="button is-link is-disabled" disabled>
              <ImageComponent fileName="google.png" altText="Google logo" class="google-logo" />
              {{ $t('googleAccountLinked') }}
            </button>
            <button @click="linkDiscordAccount" class="button is-link">
              <ImageComponent fileName="discord.png" altText="Discord logo" class="google-logo" />
              {{ $t('linkDiscordAccount') }}
            </button>
            <button @click="linkGithubAccount" class="button is-link">
              <ImageComponent fileName="github.png" altText="Github logo" class="google-logo" />
              {{ $t('linkGithubAccount') }}
            </button>
            <button @click="linkSpotifyAccount" class="button is-link">
              <ImageComponent fileName="spotify.png" altText="Spotify logo" class="google-logo" />
              {{ $t('linkSpotifyAccount') }}
            </button>
          </div>

          <div class="buttons is-centered">
            <button class="button is-link is-disabled" disabled>
              <ImageComponent fileName="github.png" altText="Github logo" class="google-logo" />
              {{ $t('disabled') }}
            </button>
            <button class="button is-link is-disabled" disabled>
              <ImageComponent fileName="spotify.png" altText="Spotify logo" class="google-logo" />
              {{ $t('disabled') }}
            </button>
          </div>
        </div>
      </div>

      <div v-if="showConfirmModal" class="modal is-active">
        <div class="modal-background"></div>
        <div class="modal-content">
          <div class="box">
            <p>{{ $t('usernameUpdateMessage') }}</p>
            <button @click="confirmUsernameUpdate" class="button is-link">{{ $t('continue') }}</button>
            <button @click="cancelUsernameUpdate" class="button">{{ $t('cancel') }}</button>
          </div>
        </div>
        <button class="modal-close is-large" aria-label="close" @click="cancelUsernameUpdate"></button>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { UserRepository } from "~/infrastructure/repositories/UserRepository";
import { getUser, updatePassword, updateUsername } from "~/domain/use-cases/user";
import { useCookie, useRouter } from '#app'
import {CookiesEnum, RoutesEnum} from "~/config/constants";
import { useSnackbar } from "~/composables/useSnackBar";
import ImageComponent from "~/components/Assets.vue";

const username = ref("")
const password = ref("")
const showConfirmModal = ref(false)
const router = useRouter()
const { showSnackbar } = useSnackbar()
const config = useRuntimeConfig()
const isLinkedGoogle = ref<boolean | null>(null)

async function changeUsername() {
  if (!username.value) {
    return
  }
  showConfirmModal.value = true
}

function cancelUsernameUpdate() {
  showConfirmModal.value = false
}

async function confirmUsernameUpdate() {
  try {
    const response = await new updateUsername(new UserRepository()).execute(username.value)
    useCookie(CookiesEnum.TOKEN.toString()).value = null
    await router.push(RoutesEnum.LOGIN.toString())
    showSnackbar('logoutSuccess', 'success')
  } catch (error: any) {
    console.error(error.message)
  } finally {
    showConfirmModal.value = false
  }
}

async function changePassword() {
  if (!password.value) {
    return
  }
  try {
    return await new updatePassword(new UserRepository()).execute(password.value)
  } catch (error: any) {
    console.error(error.message)
  }
}

async function logout() {
  useCookie(CookiesEnum.TOKEN.toString()).value = null
  await router.push(RoutesEnum.LOGIN.toString())
  showSnackbar('logoutSuccess', 'success')
}

async function fetchIsLinkedGoogle() {
  const JWTToken = useCookie(CookiesEnum.TOKEN.toString()).value
  if (!JWTToken) {
    isLinkedGoogle.value = false
    return
  }

  try {
    const response = await fetch(`${config.public.baseUrlApi}/auth/is/linked/google`, {
      method: 'GET',
      headers: {
        Authorization: `Bearer ${JWTToken}`,
        'Content-Type': 'application/json',
      },
    })

    if (!response.ok) {
      throw new Error('Failed to fetch Google link status')
    }

    const data = await response.json()
    isLinkedGoogle.value = data.linked
  } catch (error) {
    console.error('There was a problem with the fetch operation:', error)
    isLinkedGoogle.value = false
  }
}

async function linkGoogleAccount() {
  try {
    window.location.href = `${config.public.baseUrlApi}/auth/login/to/google`
  } catch (error) {
    console.error('There was a problem with the fetch operation:', error)
  }
}

async function linkDiscordAccount() {
  try {
    window.location.href = `${config.public.baseUrlApi}/auth/login/to/discord`
  } catch (error) {
    console.error('There was a problem with the fetch operation:', error)
  }
}

async function linkSpotifyAccount() {
  try {
    window.location.href = `${config.public.baseUrlApi}/auth/login/to/spotify`
  } catch (error) {
    console.error('There was a problem with the fetch operation:', error)
  }
}

async function linkGithubAccount() {
  try {
    window.location.href = `${config.public.baseUrlApi}/auth/login/to/github`
  } catch (error) {
    console.error('There was a problem with the fetch operation:', error)
  }
}


async function user() {
  try {
    return await new getUser(new UserRepository()).execute()
  } catch (error: any) {
    console.error(error.message)
    return null
  }
}

onMounted(async () => {
  await fetchIsLinkedGoogle()
  const userData = await user();
  if (userData) {
    username.value = userData['username'] || "";
  }
})

</script>

<style scoped lang="scss">
@import "https://cdn.jsdelivr.net/npm/bulma@1.0.2/css/bulma.min.css";

.profile-page {
  color: white;
}
.profile-form {
  background-color: #343434;
  padding: 20px;
  border-radius: 5px;
}
.btn-logout {
  background-color: #ff3860;
  color: white;
}
.btn-google {
  background-color: #4285f4;
  color: white;
}
.btn-google-disabled {
  background-color: #d3d3d3;
  color: white;
}
.google-logo {
  width: 20px;
  height: 20px;
  margin-right: 10px;
}
</style>
