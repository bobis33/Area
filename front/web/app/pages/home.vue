<template>
  <div>
    <button @click="logout" class="btn-logout m-5">{{ $t('logout') }}</button>

    <button
        v-if="isLinkedGoogle === false"
        @click="googleLogin"
        class="btn-google m-5"
    >
      <img src="/assets/google.png" alt="Google logo" class="google-logo" />
      {{ $t('linkGoogleAccount') }}
    </button>

    <button v-else-if="isLinkedGoogle === true" class="btn-google-disabled m-5" disabled>
      <img src="/assets/google.png" alt="Google logo" class="google-logo" />
      {{ $t('googleAccountLinked') }}
    </button>

    <button class="btn-google-disabled m-5" disabled>
      <img src="/assets/github.png" alt="Github logo" class="github-logo" />
      {{ $t('disabled') }}
    </button>

    <button @click="router.push(RoutesEnum.AREAS.toString())" class="btn-primary m-5">
      {{ $t('myAreas') }}
    </button>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useCookie, useRouter } from '#app'
import { useSnackbar } from '~/composables/useSnackBar'
import { RoutesEnum, CookiesEnum } from '~/config/constants'

const { showSnackbar } = useSnackbar()
const router = useRouter()
const config = useRuntimeConfig()

const isLinkedGoogle = ref<boolean | null>(null)

async function logout() {
  useCookie(CookiesEnum.TOKEN.toString()).value = null
  await router.push(RoutesEnum.LOGIN.toString())
  showSnackbar('logoutSuccess', 'success')
}

async function googleLogin() {
  try {
    window.location.href = `${config.public.baseUrlApi}/auth/login/to/google`
  } catch (error) {
    console.error('There was a problem with the fetch operation:', error)
  }
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

onMounted(() => {
  fetchIsLinkedGoogle()
})
</script>

<style scoped lang="scss">
@use 'assets/styles/buttons' as *;

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

.btn-github {
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #333;
  color: white;
  border: none;
  padding: 10px 20px;
  cursor: pointer;
  border-radius: 5px;
  font-size: 1rem;
  transition: background-color 0.3s ease;
  gap: 10px;

  &:hover {
    background-color: #222;
  }

  .github-logo {
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
