#region Copyright & License

// Copyright © 2012 - 2021 François Chabot
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
// http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#endregion

using System.Diagnostics.CodeAnalysis;
using Be.Stateless.BizTalk.Dsl.Environment.Settings;

namespace Be.Stateless.BizTalk.Factory.Environment.Settings
{
	[SuppressMessage("ReSharper", "ClassWithVirtualMembersNeverInherited.Global", Justification = "Allow to be provided at deployment time.")]
	public class BizTalkFactory : EnvironmentSettings<BizTalkFactory>, IEnvironmentSettings
	{
		#region IEnvironmentSettings Members

		public string ApplicationName => "BizTalk.Factory";

		#endregion

		public virtual string ReceiveHost => "BizTalkServerApplication";

		public virtual string TransmitHost => "BizTalkServerApplication";
	}
}
