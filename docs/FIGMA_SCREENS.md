# 🎨 Taxi Ale — Figma UI/UX Design System & Screens

> **Interactive Figma Prototype**: [Open Taxi Ale in Figma](https://www.figma.com/design/Fn2plgWvIrb6sldOW1LkiZ/Taxi-Ale-%E2%80%94-Public-Transit-UI-UX---Design-System?node-id=0-1&t=pWrU9bunlFsE7xq1-1)

This directory contains the visual design assets, screen wireframes, and design system specifications for **Taxi Ale (ታክሲ አለ)**.

---

## 📱 Visual Overview

Save your exported Figma overview screenshot here as `figma_overview.png`:

![Taxi Ale Figma Canvas Overview](figma_overview.png)

---

## 🧭 Screen Architecture & Flows

### 👤 1. Passenger Journey Flow
1. **`01 - Splash Screen`**
   - Branded launch screen with animated city skyline and Taxi Ale minibus icon.
2. **`02 - Role Selection`**
   - Clean fork allowing users to choose between **Passenger** and **Driver** mode with Amharic language support.
3. **`03 - Passenger Login (Default)`**
   - Phone number input field enforcing Ethiopian 9-digit MSISDN format (`+251 9...`).
4. **`04 - Passenger Login (Keypad Active)`**
   - Mobile-optimized numeric keypad for rapid one-handed phone number entry.
5. **`05 - Passenger Login (Social Alternative)`**
   - Google & Apple social sign-in bottom sheet for quick guest authentication.
6. **`06 - Passenger OTP Verification`**
   - 4-digit SMS verification PIN input with countdown resend timer.
7. **`07 - Passenger Location Permission`**
   - Dedicated GPS onboarding illustration explaining why device location is required for transit matching.
8. **`08 - Passenger Live Map & Route Discovery`**
   - Interactive OpenStreetMap view with turn-by-turn OSRM route polylines, 3D minibus icons showing live seat availability, and auto-collapsing trip sheet.

---

### 🚗 2. Driver Journey Flow
9. **`09 - Driver License Verification`**
   - Driver onboarding flow with camera and photo gallery upload for official transport accreditation.
10. **`10 - Driver Route & Vehicle Setup`**
    - Minibus license plate registration, vehicle capacity selector, and route corridor presets (e.g., *Megenagna ⇄ Mexico*).
11. **`11 - Driver Location Permission`**
    - GPS broadcast permission request to enable background position streaming to nearby commuters.
12. **`12 - Driver Active Trip HUD (Live Dashboard)`**
    - Real-time driving HUD displaying route progress, live passenger hail counter, and interactive seat availability toggle (`-` / `+`).

---

## 🎨 Design Tokens & Style Guide

### Color Palette
- **Primary Addis Teal**: `#2C7480` — Primary action buttons, active route lines, active tabs.
- **Secondary Cyan**: `#62929E` / `#5E939D` — Sub-accents, icons, secondary pills.
- **Surface Background**: `#EAF1F3` — Sheet backgrounds, cards, map overlays.
- **Slate Dark**: `#1E293B` — High-contrast typography for sunlight readability.
- **Success Green**: `#22C55E` — Available seat indicators (`3 seats free`).
- **Alert Red**: `#E53935` — Destination pin, end route button.

### Typography
- **Font Family**: Inter / Poppins / Noto Sans Ethiopic
- **Display / H1**: 22px – 24px Bold
- **Section Title / H2**: 16px – 18px SemiBold
- **Body Regular**: 14px Regular
- **Caption / Tag**: 11px – 12px Medium

---

## 📥 How to Add Your Figma Screenshots Here

1. In Figma, select your screen frames (or press `Shift + Click` to select the entire board).
2. Right click ➔ **Copy/Paste as** ➔ **Copy as PNG** (or use `File > Export`).
3. In VS Code, save or paste the image file into this folder (`my_aoo/docs/`) with the filename:
   - **`figma_overview.png`** (For the full canvas overview)
   - **`passenger_flow.png`** (Optional: for passenger screens)
   - **`driver_flow.png`** (Optional: for driver screens)
4. Commit and push:
   ```bash
   git add docs/
   git commit -m "docs: add Figma design overview and screen mockups"
   git push
   ```
