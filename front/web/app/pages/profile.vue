<template>
  <div class="profile-page">
    <h1>{{ $t('profile') }}</h1>

    <form @submit.prevent="changeUsername" class="profile-form">
      <h2>{{ $t('changeUsername') }}</h2>
      <label for="username">{{ $t('username') }}</label>
      <input
          id="username"
          type="text"
          v-model="username"
          placeholder="username"
          required
      />
      <button type="submit">{{ $t('update') }}</button>
    </form>

    <form @submit.prevent="changePassword" class="profile-form">
      <h2>{{ $t('changePassword') }}</h2>
      <label for="password">{{ $t('password') }}</label>
      <input
          id="password"
          type="password"
          v-model="password"
          placeholder="password"
          required
      />
      <button type="submit">{{ $t('update') }}</button>
    </form>

    <div>
      <button @click="logout" class="btn-logout m-5">{{ $t('logout') }}</button>

      <button
          v-if="!isLinkedGoogle"
          @click="linkGoogleAccount"
          class="btn-google m-5"
      >
        <ImageComponent fileName="google.png" altText="Google logo" class="google-logo" />
        {{ $t('linkGoogleAccount') }}
      </button>

      <button v-else-if="isLinkedGoogle" class="btn-google-disabled m-5" disabled>
        <ImageComponent fileName="google.png" altText="Google logo" class="google-logo" />
        {{ $t('googleAccountLinked') }}
      </button>

      <button class="btn-google-disabled m-5" disabled>
        <ImageComponent fileName="github.png" altText="Github logo" class="google-logo" />
        {{ $t('disabled') }}
      </button>

      <button class="btn-google-disabled m-5" disabled>
        <ImageComponent fileName="discord.png" altText="Discord logo" class="google-logo" />
        {{ $t('disabled') }}
      </button>

      <button class="btn-google-disabled m-5" disabled>
        <ImageComponent fileName="microsoft.png" altText="Microsoft logo" class="google-logo" />
        {{ $t('disabled') }}
      </button>
    </div>

    <div v-if="showConfirmModal" class="modal">
      <div class="modal-content">
        <p>{{ $t('usernameUpdateMessage') }}</p>
        <button @click="confirmUsernameUpdate">{{ $t('continue') }}</button>
        <button @click="cancelUsernameUpdate">{{ $t('cancel') }}</button>
      </div>
    </div>
  </div>
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

.profile-page {
  max-width: 600px;
  margin: 2rem auto;
  padding: 1rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);

  h1 {
    text-align: center;
    margin-bottom: 2rem;
  }

  .profile-form {
    margin-bottom: 2rem;

    h2 {
      margin-bottom: 1rem;
    }

    label {
      display: block;
      margin-bottom: 0.5rem;
      font-weight: bold;
    }

    input {
      width: 100%;
      padding: 0.5rem;
      margin-bottom: 1rem;
      border: 1px solid #ccc;
      border-radius: 4px;
    }

    button {
      display: block;
      width: 100%;
      padding: 0.75rem;
      background-color: #007bff;
      color: #fff;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      font-size: 1rem;
      transition: background-color 0.3s;

      &:hover {
        background-color: #0056b3;
      }
    }
  }
}

.modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(0, 0, 0, 0.5);

  .modal-content {
    background: #fff;
    padding: 2rem;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
    text-align: center;

    button {
      margin: 0.5rem;
      padding: 0.75rem 1.5rem;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      font-size: 1rem;
    }

    button:first-of-type {
      background-color: #007bff;
      color: #fff;
    }

    button:last-of-type {
      background-color: #ccc;
      color: #000;
    }
  }
}

.btn-logout {
  background-color: var(--error-color);
  color: white;
  border: none;
  padding: 10px 20px;
  cursor: pointer;
  border-radius: 5px;
  font-size: 1.125rem;
  transition: background-color 0.3s ease;

  &:hover {
    background-color: #dc3545;
  }
}

.btn-google {
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #4285F4;
  color: white;
  border: none;
  padding: 10px 20px;
  cursor: pointer;
  border-radius: 5px;
  font-size: 1rem;
  transition: background-color 0.3s ease;
  gap: 10px;

  &:hover {
    background-color: #357ae8;
  }

  .google-logo {
    width: 20px;
    height: 20px;
  }
}

.btn-google-disabled {
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #ddd;
  color: #aaa;
  border: none;
  padding: 10px 20px;
  border-radius: 5px;
  font-size: 1rem;
  gap: 10px;

  .google-logo {
    width: 20px;
    height: 20px;
    opacity: 0.6;
  }
}
</style>
