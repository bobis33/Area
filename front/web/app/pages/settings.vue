<template>
    <section :data-theme="$colorMode.preference" class="hero is-fullheight" :style="{ backgroundColor: 'var(--bg)' }">
      <div class="container">
        <div class="columns is-vcentered" style="padding-top: 5%; padding-bottom: 2%; color: var(--text-color);">
          <div class="column is-4"></div>
          <div class="column is-4 has-text-centered">
            <h1 class="title" :style="{color: 'var(--text-color)'}">{{ $t('Create_area') }}</h1>
          </div>
          <div class="column is-4 has-text-right">
            <div style="display: flex; justify-content: flex-end; margin-right: 10%;">
              <div style="display: flex; align-items: center; justify-content: space-between; width: 100%;">
                <nuxt-link to="/subscribedAreas" class="link-button" :style="{color: 'var(--text-color)'}">{{$t('My_areas')}}</nuxt-link>
                <nuxt-link to="/createAreas" class="link-button has-text-primary" :style="{color: 'var(--text-color)'}">{{$t('Create')}}</nuxt-link>
                <nuxt-link to="/areas" class="link-button" :style="{color: 'var(--text-color)'}">{{$t('sharedAreas')}}</nuxt-link>
                <nuxt-link to="/profile" class="link-button" :style="{color: 'var(--text-color)'}">
                  <img src="@/assets/icons/account.png" alt="Plus Icon" style="width: 30px; height: 30px; margin: 3px;" :style="{filter: 'var(--filter)'}"/>
                </nuxt-link>
              </div>
            </div>
          </div>
        </div>
        <ThemeSwitcher/>
        <LanguageSwitcher/>
      </div>
    </section>
  </template>
  
  <script setup lang="ts">
  </script>
  
  <style scoped lang="scss">
  @import "https://cdn.jsdelivr.net/npm/bulma@1.0.2/css/bulma.min.css";
  
  .is-fixed-bottom-right {
    position: fixed;
    bottom: 20px;
    right: 20px;
  }
  </style>
  