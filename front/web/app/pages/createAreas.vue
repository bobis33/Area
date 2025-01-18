<template>
  <section :data-theme="$colorMode.preference" class="hero is-fullheight" :style="{ backgroundColor: 'var(--bg)' }">
    <div class="container">
      <div class="columns is-vcentered" style="padding-top: 5%; padding-bottom: 2%; color: var(--text-color);">
        <div class="column is-4"></div>
        <div class="column is-4 has-text-centered">
          <h1 class="title" :style="{color: 'var(--text-color)'}">{{ $t('Create AREA') }}</h1>
        </div>
        <div class="column is-4 has-text-right">
          <div style="display: flex; justify-content: flex-end; margin-right: 10%;">
            <div style="display: flex; align-items: center; justify-content: space-between; width: 100%;">
              <nuxt-link to="/subscribedAreas" class="link-button" :style="{color: 'var(--text-color)'}">{{$t('My AREAS')}}</nuxt-link>
              <nuxt-link to="/createAreas" class="link-button has-text-primary" :style="{color: 'var(--text-color)'}">{{$t('Create')}}</nuxt-link>
              <nuxt-link to="/areas" class="link-button" :style="{color: 'var(--text-color)'}">{{$t('Shared AREAS')}}</nuxt-link>
              <nuxt-link to="/profile" class="link-button" :style="{color: 'var(--text-color)'}">
                <img src="@/assets/icons/account.png" alt="Plus Icon" style="width: 30px; height: 30px; margin: 3px;" :style="{filter: 'var(--filter)'}"/>
              </nuxt-link>
            </div>
          </div>
        </div>
      </div>
      <div class="columns">
        <div class="column is-2"></div>
        <div v-if="actionsData && actionsData.actions.length" class="box action-box column is-3" :style="{ backgroundColor: '#B23737', boxShadow: '0 4px 8px rgba(0, 0, 0, 0.5)' }">
          <h1 class="title is-6" :style="{color: 'white'}">{{ $t('Action') }}</h1>
          <div class="select is-fullwidth">
            <select v-model="actionSelectedService">
              <option disabled selected value="">{{ $t('Service') }}</option>
              <option v-for="service in services" :key="service" :value="service">
                {{ service }}
              </option>
            </select>
          </div>
          <div class="select is-fullwidth" v-if="actionSelectedService && filteredActions" style="margin-top: 10px;">
            <select v-model="selectedAction">
              <option disabled selected value="">{{ $t('Action') }}</option>
              <option v-for="action in filteredActions" :key="action.name" :value="action">
                {{ action.name }}
              </option>
            </select>
          </div>
          <div v-if="selectedAction && selectedAction.params">
            <div v-for="(value, key) in selectedAction.params" :key="key" class="field">
              <label class="label" :for="String(key)" :style="{color: 'white'}">{{ $t(String(key)) }}:</label>
              <div class="control">
                <input
                  v-if="value || typeof value === 'string'"
                  :id="String(key)"
                  type="text"
                  v-model="selectedAction.params[key]"
                  class="input"
                />
              </div>
            </div>
            <div v-if="selectedAction && selectedAction.description">
              <p :style="{color: 'white'}">{{ selectedAction.description }}</p>
            </div>
          </div>
        </div>

        <div class="column is-2">
          <div class="is-flex is-justify-content-center is-align-items-center" style="height: 100%;">
            <img src="@/assets/icons/right-arrow.png" alt="Right arrow" style="width: 30px; height: 30px; margin: 3px;" :style="{filter: 'var(--filter)'}"/>
          </div>
        </div>

        <div v-if="reactionsData && reactionsData.reactions.length" class="box reaction-box column is-3" :style="{ backgroundColor: '#0F4FC7', boxShadow: '0 4px 8px rgba(0, 0, 0, 0.5)' }">
          <h1 class="title is-6" :style="{color: 'white'}">{{ $t('Reaction') }}</h1>
          <div class="select is-fullwidth">
            <select v-model="reactionSelectedService">
              <option disabled selected value="">{{ $t('Service') }}</option>
              <option v-for="service in services" :key="service" :value="service">
                {{ service }}
              </option>
            </select>
          </div>
          <div class="select is-fullwidth" v-if="reactionSelectedService && filteredReactions" style="margin-top: 10px;">
            <select v-model="selectedReaction">
              <option disabled selected value="">{{ $t('Reaction') }}</option>
              <option v-for="reaction in filteredReactions" :key="reaction.name" :value="reaction">
                {{ reaction.name }}
              </option>
            </select>
          </div>
          <div v-if="selectedReaction && selectedReaction.params">
            <div v-for="(value, key) in selectedReaction.params" :key="key" class="field">
              <label class="label" :for="String(key)" :style="{color: 'white'}">{{ $t(String(key)) }}:</label>
              <div class="control">
                <input
                  v-if="value || typeof value === 'string'"
                  :id="String(key)"
                  type="text"
                  v-model="selectedReaction.params[key]"
                  class="input"
                />
              </div>
            </div>
            <div v-if="selectedReaction && selectedReaction.description">
              <p :style="{color: 'white'}">{{ selectedReaction.description }}</p>
            </div>
          </div>
          <div v-else>
            <p :style="{color: 'white'}">No reactions found.</p>
          </div>
        </div>
        <div class="column is-2"></div>

        <button @click="createArea" class="button is-primary is-fixed-bottom-right">{{$t('save')}}</button>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
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
@import "https://cdn.jsdelivr.net/npm/bulma@1.0.2/css/bulma.min.css";

.is-fixed-bottom-right {
  position: fixed;
  bottom: 20px;
  right: 20px;
}
</style>
