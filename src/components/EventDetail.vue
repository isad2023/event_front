<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import axios from 'axios'

interface EventDetail {
  id: string
  title: string
  description: string
  short_description: string
  start_date: string
  location: string
  image_path: string
  organizer: {
    name?: string
    description?: string
    image_path?: string
  }
}

const props = defineProps<{
  id: string
}>()

const router = useRouter()
const event = ref<EventDetail | null>(null)
const loading = ref(true)
const registering = ref(false)
const registered = ref(false)

const formatDateTime = computed(() => {
  if (!event.value) return ''
  const date = new Date(event.value.start_date)
  return date.toLocaleString('ru-RU', {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
})

const isUpcoming = computed(() => {
  if (!event.value) return false
  return new Date(event.value.start_date) > new Date()
})

const imageUrl = computed(() => {
  if (!event.value) return ''
  if (event.value.image_path && event.value.image_path.startsWith('http')) {
    return event.value.image_path
  }
  return event.value.image_path 
    ? `http://localhost:8000${event.value.image_path}`
    : 'https://images.pexels.com/photos/2747449/pexels-photo-2747449.jpeg?auto=compress&cs=tinysrgb&w=800'
})

const fetchEvent = async () => {
  try {
    const response = await axios.get(`http://localhost:8000/events/${props.id}`)
    event.value = response.data
  } catch (error) {
    console.error('Error fetching event:', error)
  } finally {
    loading.value = false
  }
}

const registerForEvent = async () => {
  if (!event.value) return
  
  registering.value = true
  try {
    await axios.post(`http://localhost:8000/events/${event.value.id}/register`)
    registered.value = true
  } catch (error) {
    console.error('Error registering for event:', error)
  } finally {
    registering.value = false
  }
}

onMounted(() => {
  fetchEvent()
})
</script>

<template>
  <div class="event-detail">
    <div class="back-button" @click="router.back()">
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <line x1="19" y1="12" x2="5" y2="12"/>
        <polyline points="12,19 5,12 12,5"/>
      </svg>
      Назад
    </div>

    <div v-if="loading" class="loading">
      <div class="spinner"></div>
    </div>

    <div v-else-if="!event" class="error">
      <h2>Мероприятие не найдено</h2>
    </div>

    <div v-else class="event-content">
      <div class="event-hero">
        <img :src="imageUrl" :alt="event.title" />
        <div class="hero-overlay">
          <div class="container">
            <h1 class="event-title">{{ event.title }}</h1>
            <p class="event-short-desc">{{ event.short_description }}</p>
          </div>
        </div>
      </div>

      <div class="container">
        <div class="event-info">
          <div class="main-content">
            <div class="event-meta">
              <div class="meta-item">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/>
                  <line x1="16" y1="2" x2="16" y2="6"/>
                  <line x1="8" y1="2" x2="8" y2="6"/>
                  <line x1="3" y1="10" x2="21" y2="10"/>
                </svg>
                <span>{{ formatDateTime }}</span>
              </div>
              
              <div class="meta-item">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/>
                  <circle cx="12" cy="10" r="3"/>
                </svg>
                <span>{{ event.location }}</span>
              </div>
            </div>

            <div class="event-description">
              <h2>О мероприятии</h2>
              <p>{{ event.description }}</p>
            </div>

            <div v-if="event.organizer && event.organizer.name" class="organizer-info">
              <h2>Организатор</h2>
              <div class="organizer-card">
                <div class="organizer-name">{{ event.organizer.name }}</div>
                <div v-if="event.organizer.description" class="organizer-desc">
                  {{ event.organizer.description }}
                </div>
              </div>
            </div>
          </div>

          <div class="sidebar">
            <div class="registration-card">
              <div class="status-badge" :class="{ upcoming: isUpcoming, past: !isUpcoming }">
                {{ isUpcoming ? 'Предстоящее' : 'Завершено' }}
              </div>
              
              <div v-if="isUpcoming && !registered" class="registration-section">
                <h3>Записаться на мероприятие</h3>
                <p>Не упустите возможность принять участие в этом замечательном мероприятии!</p>
                <button 
                  @click="registerForEvent" 
                  :disabled="registering"
                  class="register-btn"
                >
                  <span v-if="registering">Записываем...</span>
                  <span v-else>Записаться</span>
                </button>
              </div>

              <div v-else-if="registered" class="registered-section">
                <svg width="60" height="60" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
                  <polyline points="22,4 12,14.01 9,11.01"/>
                </svg>
                <h3>Вы записаны!</h3>
                <p>Увидимся на мероприятии. Подробности будут отправлены на вашу почту.</p>
              </div>

              <div v-else class="past-event-section">
                <h3>Мероприятие завершено</h3>
                <p>Это мероприятие уже прошло. Следите за нашими анонсами!</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.event-detail {
  min-height: 100vh;
  background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
  color: white;
}

.back-button {
  position: fixed;
  top: 2rem;
  left: 2rem;
  z-index: 100;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  background: rgba(0, 0, 0, 0.8);
  backdrop-filter: blur(10px);
  color: white;
  border: none;
  border-radius: 8px;
  padding: 0.75rem 1rem;
  font-size: 0.95rem;
  cursor: pointer;
  transition: all 0.3s ease;
}

.back-button:hover {
  background: rgba(255, 107, 53, 0.8);
}

.loading {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
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

.error {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
}

.event-hero {
  position: relative;
  height: 400px;
  overflow: hidden;
}

.event-hero img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.hero-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(180deg, rgba(0, 0, 0, 0.3) 0%, rgba(0, 0, 0, 0.8) 100%);
  display: flex;
  align-items: end;
  padding: 4rem 0;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
}

.event-title {
  margin: 0 0 1rem 0;
  font-size: 3rem;
  font-weight: 700;
  line-height: 1.2;
}

.event-short-desc {
  margin: 0;
  font-size: 1.25rem;
  opacity: 0.9;
  max-width: 600px;
}

.event-info {
  display: grid;
  grid-template-columns: 1fr 350px;
  gap: 3rem;
  margin: 3rem 0;
}

.event-meta {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  margin-bottom: 2rem;
  padding: 1.5rem;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 12px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.meta-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  color: #ff6b35;
  font-size: 1rem;
  font-weight: 500;
}

.meta-item span {
  color: white;
}

.event-description h2,
.organizer-info h2 {
  margin: 0 0 1rem 0;
  font-size: 1.5rem;
  font-weight: 600;
  color: #ff6b35;
}

.event-description p,
.organizer-desc {
  margin: 0;
  line-height: 1.6;
  font-size: 1.1rem;
  opacity: 0.9;
}

.organizer-info {
  margin-top: 3rem;
}

.organizer-card {
  padding: 1.5rem;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 12px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.organizer-name {
  font-size: 1.25rem;
  font-weight: 600;
  margin-bottom: 0.5rem;
}

.registration-card {
  position: sticky;
  top: 2rem;
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(10px);
  border-radius: 16px;
  padding: 2rem;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.status-badge {
  display: inline-block;
  padding: 0.5rem 1rem;
  border-radius: 20px;
  font-size: 0.9rem;
  font-weight: 600;
  margin-bottom: 1.5rem;
}

.status-badge.upcoming {
  background: linear-gradient(135deg, #4caf50, #66bb6a);
  color: white;
}

.status-badge.past {
  background: rgba(156, 163, 175, 0.3);
  color: #9ca3af;
}

.registration-section h3,
.registered-section h3,
.past-event-section h3 {
  margin: 0 0 1rem 0;
  font-size: 1.25rem;
  font-weight: 600;
}

.registration-section p,
.registered-section p,
.past-event-section p {
  margin: 0 0 1.5rem 0;
  opacity: 0.8;
  line-height: 1.5;
}

.register-btn {
  width: 100%;
  background: linear-gradient(135deg, #ff6b35, #ffa726);
  color: white;
  border: none;
  border-radius: 12px;
  padding: 1rem;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.register-btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(255, 107, 53, 0.4);
}

.register-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.registered-section {
  text-align: center;
}

.registered-section svg {
  color: #4caf50;
  margin-bottom: 1rem;
}

.past-event-section {
  text-align: center;
  opacity: 0.7;
}

@media (max-width: 1024px) {
  .event-info {
    grid-template-columns: 1fr;
    gap: 2rem;
  }

  .registration-card {
    position: static;
  }
}

@media (max-width: 768px) {
  .back-button {
    top: 1rem;
    left: 1rem;
  }

  .event-hero {
    height: 300px;
  }

  .event-title {
    font-size: 2rem;
  }

  .event-short-desc {
    font-size: 1.1rem;
  }
}
</style>