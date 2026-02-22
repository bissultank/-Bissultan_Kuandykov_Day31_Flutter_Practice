# TMDB — эндпоинты для деталки фильма (описание, рейтинг, актёры, галерея)

## База и авторизация

**Base URL (v3):** `https://api.themoviedb.org/3`

**Рекомендуемая авторизация:** Bearer Token (Read Access Token)

**Headers:**

- `Authorization: Bearer <TMDB_READ_ACCESS_TOKEN>`
- `Content-Type: application/json`

---

## 1) Детали фильма (описание + рейтинг + базовые поля)

**GET** `/movie/{movie_id}`  
Док: https://developer.themoviedb.org/reference/movie-details

**Пример:**

GET https://api.themoviedb.org/3/movie/550?language=ru-RU
Authorization: Bearer

**Основные поля для UI:**

- `title`
- `overview` (описание)
- `vote_average` (рейтинг)
- `vote_count` (кол-во голосов)
- `release_date`
- `runtime`
- `genres[]`

---

## 2) Актёры

### Вариант A (отдельный запрос)

**GET** `/movie/{movie_id}/credits`  
Док: https://developer.themoviedb.org/reference/movie-credits

**Пример:**

GET https://api.themoviedb.org/3/movie/550/credits?language=ru-RU
Authorization: Bearer

**Что брать из `cast[]`:**

- `name`
- `character`
- `profile_path` (фото актёра)

---

## 3) Галерея (posters / backdrops)

### Вариант A (отдельный запрос)

**GET** `/movie/{movie_id}/images`  
Док: https://developer.themoviedb.org/reference/movie-images

**Пример:**

GET https://api.themoviedb.org/3/movie/550/images?include_image_language=en,null
Authorization: Bearer

**Что брать:**

- `backdrops[]` и/или `posters[]`
- у каждого: `file_path`

---

## 4) Лучший вариант: один запрос через append_to_response

Чтобы не делать 3 запроса, делай 1 запрос:

**GET** `/movie/{movie_id}?append_to_response=credits,images`  
Док: https://developer.themoviedb.org/docs/append-to-response

**Пример:**

GET https://api.themoviedb.org/3/movie/550?language=ru-RU&append_to_response=credits,images&include_image_language=en,null
Authorization: Bearer

**Что появится в ответе:**

- `credits` (актёры/съёмочная группа)
- `images` (галерея)

---

## 5) Как собрать URL изображений

TMDB возвращает только `file_path`. Полный URL строится так:

`https://image.tmdb.org/t/p/<size><file_path>`

Док: https://developer.themoviedb.org/docs/image-basics

**Примеры размеров:**

- Постеры/профили: `w342`, `w500`, `original`
- Бэкдропы: `w780`, `w1280`, `original`

**Примеры:**

- Poster/Profile: `https://image.tmdb.org/t/p/w500<file_path>`
- Backdrop/Banner: `https://image.tmdb.org/t/p/w1280<file_path>`

---

## Итог (минимум под твою деталку)

**Один запрос:**

- `/movie/{id}?append_to_response=credits,images`

**Поля для UI:**

- Описание: `overview`
- Рейтинг: `vote_average`
- Актёры: `credits.cast[]`
- Галерея: `images.backdrops[]` / `images.posters[]`
