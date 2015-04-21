/*
 * Copyright (C) 2015~2015 by CSSlayer
 * wengxt@gmail.com
 *
 * This library is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation; either version 2 of the
 * License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; see the file COPYING. If not,
 * see <http://www.gnu.org/licenses/>.
 */

#ifndef COMMON_H
#define COMMON_H

#include "fcitxgclient_export.h"

#define FCITXGCLIENT_UNUSED(X) ((void) X);

#if 0
#define fcitx_gclient_debug(...) g_log ("fcitx-client",       \
                                      G_LOG_LEVEL_DEBUG,    \
                                      __VA_ARGS__)

#else
#define fcitx_gclient_debug(...)
#endif

#endif // COMMON_H
