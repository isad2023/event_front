<script setup lang="ts">
import { ref } from 'vue'
import axios from 'axios'

const emit = defineEmits<{
  close: []
  created: []
}>()

const form = ref({
  title: '',
  description: '',
  short_description: '',
  start_date: '',
  location: '',
  image_path: '',
  organizer_name: '',
  organizer_description: ''
})

const creating = ref(false)

const formatDateTimeForInput = () => {
  const now = new Date()
  const year = now.getFullYear()
  const month = String(now.getMonth() + 1).padStart(2, '0')
  const day = String(now.getDate()).padStart(2, '0')
  const hours = String(now.getHours()).padStart(2, '0')
  const minutes = String(now.getMinutes()).padStart(2, '0')
  
  return `${year}-${month}-${day}T${hours}:${minutes}`
}

const createEvent = async () => {
  creating.value = true
  try {
    const payload = {
      ...form.value,
      start_date: new Date(form.value.start_date).toISOString()
    }
    
    await axios.post('http://localhost:8000/events', payload)
    emit('created')
  } catch (error) {
    console.error('Error creating event:', error)
  } finally {
    creating.value = false
  }
}

// Установить минимальную дату как текущее время
const minDateTime = formatDateTimeForInput()
</script>

<template>
  <div class="modal-overlay" @click="emit('close')">
    <div class="modal-content" @click.stop>
      <div class="modal-header">
        <h2>Создать мероприятие</h2>
        <button @click="emit('close')" class="close-btn">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <line x1="18" y1="6" x2="6" y2="18"/>
            <line x1="6" y1="6" x2="18" y2="18"/>
          </svg>
        </button>
      </div>

      <form @submit.prevent="createEvent" class="event-form">
        <div class="form-group">
          <label for="title">Название мероприятия *</label>
          <input 
            id="title"
            v-model="form.title" 
            type="text" 
            required 
            placeholder="Введите название мероприятия"
          />
        </div>

        <div class="form-group">
          <label for="short_description">Краткое описание *</label>
          <textarea 
            id="short_description"
            v-model="form.short_description" 
            required 
            rows="2"
            placeholder="Краткое описание для карточки"
          ></textarea>
        </div>

        <div class="form-group">
          <label for="description">Подробное описание *</label>
          <textarea 
            id="description"
            v-model="form.description" 
            required 
            rows="4"
            placeholder="Подробное описание мероприятия"
          ></textarea>
        </div>

        <div class="form-row">
          <div class="form-group">
            <label for="start_date">Дата и время *</label>
            <input 
              id="start_date"
              v-model="form.start_date" 
              type="datetime-local" 
              required 
              :min="minDateTime"
            />
          </div>

          <div class="form-group">
            <label for="location">Место проведения *</label>
            <input 
              id="location"
              v-model="form.location" 
              type="text" 
              required 
              placeholder="Адрес или название места"
            />
          </div>
        </div>

        <div class="form-group">
          <label for="image_path">Ссылка на изображение</label>
          <input 
            id="image_path"
            v-model="form.image_path" 
            type="url" 
            placeholder="https://example.com/image.jpg"
          />
        </div>

        <div class="form-group" v-if="form.image_path">
          <label>Предпросмотр изображения:</label>
          <img :src="form.image_path" alt="Preview" style="max-width: 100%; max-height: 200px; border-radius: 8px; margin-top: 8px;" />
        </div>

        <div class="organizer-section">
          <h3>Организатор</h3>
          
          <div class="form-group">
            <label for="organizer_name">Название организации *</label>
            <input 
              id="organizer_name"
              v-model="form.organizer_name" 
              type="text" 
              required 
              placeholder="Название организации"
            />
          </div>

          <div class="form-group">
            <label for="organizer_description">Описание организации</label>
            <textarea 
              id="organizer_description"
              v-model="form.organizer_description" 
              rows="3"
              placeholder="Краткая информация об организации"
            ></textarea>
          </div>
        </div>

        <div class="form-actions">
          <button type="button" @click="emit('close')" class="cancel-btn">
            Отмена
          </button>
          <button type="submit" :disabled="creating" class="submit-btn">
            <span v-if="creating">Создание...</span>
            <span v-else>Создать мероприятие</span>
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<style scoped>
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.8);
  backdrop-filter: blur(4px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  padding: 2rem;
}

.modal-content {
  background: linear-gradient(135deg, #2d2d2d, #1a1a1a);
  border-radius: 20px;
  width: 100%;
  max-width: 600px;
  max-height: 90vh;
  overflow: hidden;
  border: 1px solid rgba(255, 255, 255, 0.1);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.5);
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 2rem 2rem 1rem 2rem;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.modal-header h2 {
  margin: 0;
  color: white;
  font-size: 1.5rem;
  font-weight: 600;
}

.close-btn {
  background: none;
  border: none;
  color: rgba(255, 255, 255, 0.6);
  cursor: pointer;
  padding: 0.5rem;
  border-radius: 8px;
  transition: all 0.3s ease;
}

.close-btn:hover {
  color: white;
  background: rgba(255, 255, 255, 0.1);
}

.event-form {
  padding: 2rem;
  overflow-y: auto;
  max-height: calc(90vh - 100px);
}

.form-group {
  margin-bottom: 1.5rem;
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  color: rgba(255, 255, 255, 0.9);
  font-weight: 500;
  font-size: 0.95rem;
}

.form-group input,
.form-group textarea {
  width: 100%;
  padding: 0.75rem 1rem;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 8px;
  color: white;
  font-size: 1rem;
  transition: all 0.3s ease;
}

.form-group input:focus,
.form-group textarea:focus {
  outline: none;
  border-color: #ff6b35;
  box-shadow: 0 0 0 3px rgba(255, 107, 53, 0.2);
}

.form-group input::placeholder,
.form-group textarea::placeholder {
  color: rgba(255, 255, 255, 0.5);
}

.organizer-section {
  margin-top: 2rem;
  padding-top: 2rem;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.organizer-section h3 {
  margin: 0 0 1.5rem 0;
  color: #ff6b35;
  font-size: 1.25rem;
  font-weight: 600;
}

.form-actions {
  display: flex;
  gap: 1rem;
  margin-top: 2rem;
  padding-top: 2rem;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.cancel-btn,
.submit-btn {
  flex: 1;
  padding: 1rem;
  border: none;
  border-radius: 12px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.cancel-btn {
  background: rgba(255, 255, 255, 0.1);
  color: rgba(255, 255, 255, 0.8);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.cancel-btn:hover {
  background: rgba(255, 255, 255, 0.2);
  color: white;
}

.submit-btn {
  background: linear-gradient(135deg, #ff6b35, #ffa726);
  color: white;
}

.submit-btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(255, 107, 53, 0.4);
}

.submit-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
  transform: none;
}

@media (max-width: 768px) {
  .modal-overlay {
    padding: 1rem;
  }

  .modal-header {
    padding: 1.5rem 1.5rem 1rem 1.5rem;
  }

  .event-form {
    padding: 1.5rem;
  }

  .form-row {
    grid-template-columns: 1fr;
  }

  .form-actions {
    flex-direction: column;
  }
}
</style>