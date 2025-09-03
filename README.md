# PrecifikApp

PrecifikApp is a Ruby on Rails application designed to manage clients, users, and administrative operations for a subscription‑based business.  
It includes separate areas for **System Admins** and **Clients**, with authentication, authorization, and role‑based access control.

---

## Table of Contents
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Authentication & Authorization](#authentication--authorization)
- [Routes Overview](#routes-overview)
- [Setup & Installation](#setup--installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

---

## Features

### Client Area
- **User Management**:
  - Create, edit, and delete `user_clients` (only accessible to admins within the client account).
  - Assign `admin` role to specific users.
  - Automatic assignment of `client_id` to new users based on the creator’s account.
  - Password and password confirmation fields available in both creation and edit forms.
  - Prevent self‑deletion for the logged‑in user.
  - Confirmation prompt on deletion showing user ID and full name.
- **Settings Dashboard**:
  - View company information (legal name, trade name, CNPJ, address, plan).
  - View and manage all users belonging to the same client.
- **Authentication**:
  - Devise‑based login for `user_clients`.
  - Role check (`admin: true`) required for sensitive actions.

### System Admin Area
- Manage `user_admins`, `user_clients`, `plans`, `banners`, and `clients`.
- Separate authentication for `user_admins`.

---

## Tech Stack
- **Ruby**: 3.x
- **Rails**: 7.x
- **Database**: PostgreSQL
- **Authentication**: Devise
- **Frontend**: ERB templates, Turbo (Hotwire)
- **CSS**: Custom stylesheets

---

## Project Structure