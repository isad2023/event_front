<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import axios from 'axios'
import EventCard from './EventCard.vue'
import EventCreator from './EventCreator.vue'

interface Event {
  id: string
  title: string
  short_description: string
  start_date: string
  location: string
  image_path: string
}

const router = useRouter()
const events = ref<Event[]>([])
const loading = ref(true)
const showCreator = ref(false)
const activeTab = ref<'upcoming' | 'past'>('upcoming')

const upcomingEvents = computed(() => {
  const now = new Date()
  return events.value
    .filter(event => new Date(event.start_date) > now)
    .sort((a, b) => new Date(a.start_date).getTime() - new Date(b.start_date).getTime())
})

const pastEvents = computed(() => {
  const now = new Date()
  return events.value
    .filter(event => new Date(event.start_date) <= now)
    .sort((a, b) => new Date(b.start_date).getTime() - new Date(a.start_date).getTime())
})

const currentEvents = computed(() => {
  return activeTab.value === 'upcoming' ? upcomingEvents.value : pastEvents.value
})

const fetchEvents = async () => {
  try {
    const response = await axios.get('http://localhost:8000/events')
    events.value = response.data.events || []
  } catch (error) {
    console.error('Error fetching events:', error)
  } finally {
    loading.value = false
  }
}

const handleEventCreated = () => {
  showCreator.value = false
  fetchEvents()
}

const openFeedback = () => {
  window.open('https://db.itatmisis.ru/dashboard/#/nc/form/fde864d2-6e24-4d4c-8a28-365f22f98d9d', '_blank')
}

onMounted(() => {
  fetchEvents()
})
</script>

<template>
  <div class="home-page">
    <div class="page-header">
      <div class="container">
        <h1 class="title">Мероприятия</h1>
        <button @click="showCreator = true" class="create-btn">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <line x1="12" y1="5" x2="12" y2="19"/>
            <line x1="5" y1="12" x2="19" y2="12"/>
          </svg>
          Создать мероприятие
        </button>
      </div>
    </div>

    <div class="container">
      <div class="tabs">
        <button 
          @click="activeTab = 'upcoming'" 
          :class="['tab', { active: activeTab === 'upcoming' }]"
        >
          Актуальные ({{ upcomingEvents.length }})
        </button>
        <button 
          @click="activeTab = 'past'" 
          :class="['tab', { active: activeTab === 'past' }]"
        >
          Завершенные ({{ pastEvents.length }})
        </button>
      </div>

      <div v-if="loading" class="loading">
        <div class="spinner"></div>
      </div>

      <div v-else-if="currentEvents.length === 0" class="empty-state">
        <svg width="80" height="80" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1">
          <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/>
          <line x1="16" y1="2" x2="16" y2="6"/>
          <line x1="8" y1="2" x2="8" y2="6"/>
          <line x1="3" y1="10" x2="21" y2="10"/>
        </svg>
        <p>{{ activeTab === 'upcoming' ? 'Нет актуальных мероприятий' : 'Нет завершенных мероприятий' }}</p>
      </div>

      <div v-else class="events-grid">
        <EventCard 
          v-for="event in currentEvents" 
          :key="event.id" 
          :event="event"
          @click="router.push(`/event/${event.id}`)"
        />
      </div>
    </div>

    <footer class="footer">
      <div class="container">
        <button @click="openFeedback" class="feedback-btn">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
          </svg>
          Feedback
        </button>
      </div>
    </footer>

    <EventCreator 
      v-if="showCreator" 
      @close="showCreator = false"
      @created="handleEventCreated"
    />
  </div>
</template>

<style scoped>
.home-page {
  min-height: 100vh;
  background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
  color: white;
  display: flex;
  flex-direction: column;
}

.page-header {
  background: rgba(0, 0, 0, 0.3);
  backdrop-filter: blur(10px);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  padding: 2rem 0;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
}

.page-header .container {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.title {
  margin: 0;
  font-size: 2.5rem;
  font-weight: 700;
  background: linear-gradient(135deg, #ff6b35, #ffa726);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.create-btn {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  background: linear-gradient(135deg, #ff6b35, #ffa726);
  color: white;
  border: none;
  border-radius: 12px;
  padding: 1rem 1.5rem;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 4px 12px rgba(255, 107, 53, 0.3);
}

.create-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(255, 107, 53, 0.4);
}

.tabs {
  display: flex;
  gap: 1rem;
  margin: 3rem 0 2rem 0;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.tab {
  background: none;
  color: rgba(255, 255, 255, 0.6);
  border: none;
  padding: 1rem 1.5rem;
  font-size: 1.1rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
  border-bottom: 2px solid transparent;
}

.tab.active {
  color: #ff6b35;
  border-bottom-color: #ff6b35;
}

.tab:hover {
  color: rgba(255, 255, 255, 0.9);
}

.loading {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 300px;
}

.spinner {
  width: 40px;
  height: 40px;
  border: 3px solid rgba(255, 255, 255, 0.3);
  border-top-color: #ff6b35;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 300px;
  gap: 1rem;
  opacity: 0.6;
}

.empty-state svg {
  opacity: 0.5;
}

.events-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(450px, 1fr));
  gap: 2rem;
  margin-bottom: 3rem;
  flex: 1;
}

.footer {
  margin-top: auto;
  padding: 2rem 0;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  background: rgba(0, 0, 0, 0.2);
}

.footer .container {
  display: flex;
  justify-content: center;
}

.feedback-btn {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  background: rgba(255, 255, 255, 0.1);
  color: rgba(255, 255, 255, 0.8);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 12px;
  padding: 1rem 1.5rem;
  font-size: 1rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
}

.feedback-btn:hover {
  background: rgba(255, 255, 255, 0.2);
  color: white;
  border-color: rgba(255, 255, 255, 0.3);
  transform: translateY(-2px);
}

@media (max-width: 768px) {
  .page-header .container {
    flex-direction: column;
    gap: 1rem;
  }

  .title {
    font-size: 2rem;
  }

  .events-grid {
    grid-template-columns: 1fr;
  }

  .tabs {
    flex-direction: column;
    gap: 0;
  }

  .tab {
    text-align: left;
    padding: 1rem 0;
  }

  .container {
    padding: 0 1.5rem;
  }
}
</style>